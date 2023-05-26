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

# Create a conda environment for sirepo-bluesky
conda create -n sirepo-bluesky -c conda-forge python=3.10 ipython
conda activate sirepo-bluesky
pip install sirepo-bluesky
pip list
conda list

# Make a source dir for repos
mkdir -p $HOME/src/

# Clone the repo for dev:
git clone https://github.com/NSLS-II/sirepo-bluesky
cd sirepo-bluesky/
pip install -r requirements-dev.txt

# Start Sirepo Docker container:
bash scripts/start_sirepo.sh -d

# Copy databroker config:
mkdir -v -p ~/.config/databroker/
cp -v examples/local.yml ~/.config/databroker/

# Run tests to make sure the code is working:
pytest -s -vv

# TODO: may be useful in the future.
# # Install playwright and its dependencies
# pip install playwright
# playwright install
# playwright install-deps
