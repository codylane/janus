MINICONDA_ROOT_URI="https://repo.anaconda.com/miniconda/Miniconda3-latest"
EXPECTED_MINICONDA_INSTALLER_SHA256=1314b90489f154602fd794accfc90446111514a5a72fe1f71ab83e07de9504a7
MINICONDA_DEFAULT_PREFIX="${HOME}/miniconda3"

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

get_sha256_of_file()
{
  openssl sha256 "${1}" 2>>/dev/null | awk '{print $2}'
}


download_miniconda()
{
  get_os

  ACTUAL_MINICONDA_INSTALLER_SHA256="$(get_sha256_of_file ${HOME}/miniconda3-latest-installer.sh)"
  [ "${ACTUAL_MINICONDA_INSTALLER_SHA256}" == "${EXPECTED_MINICONDA_INSTALLER_SHA256}" ] || curl -L "${MINICONDA_ROOT_URI}" -o ${HOME}/miniconda3-latest-installer.sh

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

install_janus()
{
  local required_packages=

  command -v git   >>/dev/null || required_packages="${required_packages} git"
  command -v ruby  >>/dev/null || required_packages="${required_packages} ruby"
  command -v ctags >>/dev/null || required_packages="${required_packages} ctags"
  command -v ack   >>/dev/null || required_packages="${required_packages} ack"
  command -v rake  >>/dev/null || required_packages="${required_packages} rake"

  [ -d ~/.vim ] || git clone https://github.com/carlhuda/janus ~/.vim
  if [ -n "${required_packages}" ]; then
    echo "Please make sure that you have the following packages installed [${required_packages}]"
    return 1
  fi

  cd ~/.vim
  ./bootstrap.sh
  rm -rf janus/vim/tools/vimcss-color
  sed -i.bak -e '/css-color/d' janus/submodules.yaml
  mkdir -p  ~/.janus/

  cd ~/.janus
  [ -d ansible-vim ]        || git clone https://github.com/pearofducks/ansible-vim.git
  [ -d tabular ]            || git clone https://github.com/godlygeek/tabular.git
  [ -d tcomment_vim ]       || git clone https://github.com/tomtom/tcomment_vim.git
  [ -d vim-flake8 ]         || git clone https://github.com/nvie/vim-flake8.git
  [ -d vim-puppet ]         || git clone https://github.com/rodjek/vim-puppet.git
  [ -d vim-tmux-navigator ] || git clone https://github.com/christoomey/vim-tmux-navigator.git
  [ -d vim-airline ]        || git clone  https://github.com/vim-airline/vim-airline.git

  # 2024-04-24 added this because these no longer work
  rm -rf ~/.vim/janus/vim/tools/tlib/
  rm -rf ~/.vim/janus/vim/tools/supertab/

  mkdir -p ~/nvim
  mkdir -p ~/.config/nvim
  ln -sf ~/.vimrc ~/nvim/init.vim
  ln -sf ~/.vimrc ~/.config/nvim/init.vim

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
    ~/.vimrc.after


  echo
  echo "Sucessfully installed janus!"
  echo

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
