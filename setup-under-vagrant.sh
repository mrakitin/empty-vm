#!/bin/bash

# For reference: https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html.
set -vxeuo pipefail

# Test docker under vagrant
docker run hello-world

# Git CLI conveniences
# https://github.com/magicmonty/bash-git-prompt
if [ ! -d "$HOME/.bash-git-prompt" ]; then
    git clone https://github.com/magicmonty/bash-git-prompt.git $HOME/.bash-git-prompt --depth=1
fi

# https://stackoverflow.com/a/65011702/4143531
cat << 'EOF' >> $HOME/.bashrc

if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    source $HOME/.bash-git-prompt/gitprompt.sh
fi

EOF

touch $HOME/.Xauthority

# Install mambaforge
if [ ! -d "$HOME/mambaforge" ]; then
    wget --no-hst --progress=dot:giga https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh -O /tmp/mambaforge.sh
    bash /tmp/mambaforge.sh -b -p $HOME/mambaforge
    rm -fv /tmp/mambaforge.sh
    echo 'source $HOME/mambaforge/etc/profile.d/conda.sh' >> $HOME/.bashrc
fi
source $HOME/mambaforge/etc/profile.d/conda.sh

# Info
env | sort -u

# Create a dev conda env
which conda
conda create -c conda-forge -y -n wormland python=3.10 ipython nodejs

# Clone the repo
mkdir -p $HOME/src/
if [ ! -d "$HOME/src/bnl-wormland" ]; then
    cp -rv /repo/ $HOME/src/bnl-wormland
fi

cd $HOME/src/bnl-wormland/

conda activate wormland
pip install -r backend/requirements.txt -r backend/requirements-dev.txt

# Install playwright and its dependencies
pip install playwright
playwright install
playwright install-deps

# Build docker images
docker build -t frontend -f docker/Dockerfile.frontend .
docker build -t backend -f docker/Dockerfile.backend .
docker images
sed -i -r 's#http://127.0.0.1:8000#http://backend#' frontend/vite.config.js

( cd frontend && npm install )

docker compose -f docker/docker-compose.yml up --detach

sleep 10

docker compose -f docker/docker-compose.yml ps -a

python test_end_to_end.py

