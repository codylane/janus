MINICONDA_ROOT_URI="https://repo.anaconda.com/miniconda/Miniconda3-latest"
MINICONDA_DEFAULT_PREFIX="${HOME}/miniconda3"

_update_git_module()
{

  local dir="${1}"

  cd "${1}"

  git fetch --all
  git pull

  cd -

}


err()
{
  echo "ERR: $* exiting" >&2
  exit 1
}

path_contains()
{
  echo "${PATH}" | grep -q "${1}"
}


install_gem()
{
  gem list -i "${1}" >>/dev/null 2>&1 || gem install "${1}"
}


install_gems()
{
  for gem in $@
  do
    install_gem "${gem}"
  done
}


install_ruby()
{
  command -v ruby-build >>/dev/null || return 1
  mkdir -p "${HOME}/.rubies/"

  [ -d "${HOME}/.rubies/${1}" ] || ruby-build "${1}" "${HOME}/.rubies/${1}"
}

get_os()
{
  case "$(uname -s)" in

    Darwin)
      MINICONDA_ROOT_URI="${MINICONDA_ROOT_URI}-MacOSX-$(uname -m).sh"
    ;;

    Linux)
      MINICONDA_ROOT_URI="${MINICONDA_ROOT_URI}-Linux-$(uname -m).sh"
    ;;

    *)
      return 1
    ;;
  esac
}


download_miniconda()
{
  get_os

  curl -L "${MINICONDA_ROOT_URI}" -o ${HOME}/miniconda3-latest-installer.sh

  chmod 755 ${HOME}/miniconda3-latest-installer.sh
}


install_miniconda()
{

  [ -f ${HOME}/miniconda3-latest-installer.sh ] || download_miniconda
  [ -d "${MINICONDA_DEFAULT_PREFIX}" ] || ${HOME}/miniconda3-latest-installer.sh -b -u -p "${MINICONDA_DEFAULT_PREFIX}"
}


source_miniconda()
{
  [ -f ${MINICONDA_DEFAULT_PREFIX}/etc/profile.d/conda.sh ] && . ${MINICONDA_DEFAULT_PREFIX}/etc/profile.d/conda.sh || true
}


install_janus_plugins()
{
  local required_packages=

  command -v git   >>/dev/null || required_packages="${required_packages} git"
  command -v ruby  >>/dev/null || required_packages="${required_packages} ruby"
  command -v ctags >>/dev/null || required_packages="${required_packages} ctags"
  command -v ack   >>/dev/null || required_packages="${required_packages} ack"
  command -v rake  >>/dev/null || required_packages="${required_packages} rake"

  if [ -n "${required_packages}" ]; then
    echo "Please make sure that you have the following packages installed [${required_packages}]"
    return 1
  fi

  mkdir -p  ${HOME}/.janus/
  cd ${HOME}/.janus

  [ -d ansible-vim ]        && _update_git_module ansible-vim        || git clone https://github.com/pearofducks/ansible-vim.git
  [ -d tabular ]            && _update_git_module tabular            || git clone https://github.com/godlygeek/tabular.git
  [ -d tcomment_vim ]       && _update_git_module tcomment_vim       || git clone https://github.com/tomtom/tcomment_vim.git
  [ -d vim-flake8 ]         && _update_git_module vim-flake8         || git clone https://github.com/nvie/vim-flake8.git
  [ -d vim-puppet ]         && _update_git_module vim-puppet         || git clone https://github.com/rodjek/vim-puppet.git
  [ -d vim-tmux-navigator ] && _update_git_module vim-tmux-navigator || git clone https://github.com/christoomey/vim-tmux-navigator.git
  [ -d vim-airline ]        && _update_git_module vim-airline        || git clone https://github.com/vim-airline/vim-airline.git
  [ -d vim-arduino ]        && _update_git_module vim-arduino        || git clone https://github.com/stevearc/vim-arduino.git

  cat > update-submodules.sh << 'EOS'
#!/usr/bin/env bash

BLACK="\033[0;30m"
BLACKBOLD="\033[1;30m"
RED="\033[0;31m"
REDBOLD="\033[1;31m"
GREEN="\033[0;32m"
GREENBOLD="\033[1;32m"
YELLOW="\033[0;33m"
YELLOWBOLD="\033[1;33m"
BLUE="\033[0;34m"
BLUEBOLD="\033[1;34m"
PURPLE="\033[0;35m"
PURPLEBOLD="\033[1;35m"
CYAN="\033[0;36m"
CYANBOLD="\033[1;36m"
WHITE="\033[0;37m"
WHITEBOLD="\033[1;37m"


info() {
    MSG_COLOR="${MSG_COLOR:-${GREENBOLD}}"

    echo -en "${MSG_COLOR}${@}\033[0m"
    echo
}


update() {
  find . -maxdepth 1 -type d ! -path '.' -and ! -path '..' | while read directory
  do
    pushd "${directory}" >>/dev/null

    info "${GREENBOLD}" "Updating $(basename $directory)...."
    git pull
    echo
    popd >>/dev/null
  done
}


main() {
    update
}


## main ##
main
EOS

chmod 0755 update-submodules.sh
./update-submodules.sh

}


install_neovim()
{

  mkdir -p ${HOME}/nvim
  mkdir -p ${HOME}/.config/nvim
  ln -sf ${HOME}/.vimrc ${HOME}/nvim/init.vim
  ln -sf ${HOME}/.vimrc ${HOME}/.config/nvim/init.vim

  cd ${HOME}
  curl -kLO https://raw.githubusercontent.com/codylane/dotfiles/master/.vimrc.after
  curl -kLO https://raw.githubusercontent.com/codylane/dotfiles/master/.vimrc.before
  curl -kLO https://raw.githubusercontent.com/codylane/dotfiles/master/.bash_prompt
  curl -kLO https://raw.githubusercontent.com/codylane/dotfiles/master/.aliases

  command -v pip2 >>/dev/null 2>&1
  if [ $? -eq 0 ]; then
    pip2 install --user neovim
    pip2 install --user pyvim
  fi

  command -v pip3 >>/dev/null 2>&1
  if [ $? -eq 0 ]; then
    pip3 install --user neovim
    pip3 install --user pyvim
  fi

  sed -e 's/^let g:python_host_prog/" let g:python_host_prog/g' \
    -e 's/^let g:python3_host_prog/" let g:python3_host_prog/g' \
    -e 's/^let g:ruby_host_prog/" let g:ruby_host_prog/g'       \
    -i.bak                                                      \
    ${HOME}/.vimrc.after
}


install_ruby_build()
{
  if [ -d ${HOME}/ruby-build ]; then
    cd ${HOME}/ruby-build
    git pull
    cd - >>/dev/null

  else
    git clone https://github.com/rbenv/ruby-build.git ${HOME}/ruby-build

  fi

  path_contains "${HOME}/ruby-build/bin" || export PATH="${HOME}/ruby-build/bin:${PATH}"
}


# User specific environment
PATH="$HOME/.local/bin:$HOME/bin:$PATH:${MINICONDA_DEFAULT_PREFIX}/bin"
export PATH

[ -f ${HOME}/.aliases ]     && . ${HOME}/.aliases || true
[ -f ${HOME}/.bash_prompt ] && . ${HOME}/.bash_prompt || true
