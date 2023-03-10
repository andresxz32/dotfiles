function cdd() {
  cd "$(ls -d -- */ | fzf)" || echo "Invalid directory"
}

function j() {
  fname=$(declare -f -F _z)

  [ -n "$fname" ] || source "$DOTLY_PATH/modules/z/z.sh"

  _z "$1"
}

function recent_dirs() {
  # This script depends on pushd. It works better with autopush enabled in ZSH
  escaped_home=$(echo $HOME | sed 's/\//\\\//g')
  selected=$(dirs -p | sort -u | fzf)

  cd "$(echo "$selected" | sed "s/\~/$escaped_home/")" || echo "Invalid directory"
}

reverse-search() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail HIST_FIND_NO_DUPS 2> /dev/null

  selected=( $(fc -rl 1 |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" fzf) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init
  return $ret
}

clone_git_repo() {
  repo_url=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/user/repos?per_page=200" | jq --raw-output ".[].ssh_url" | fzf)
  git clone "$repo_url"
  echo "$repo_url"
}

docker_connect() {
  containerid=$(docker ps | tail -n +2 | fzf | awk '{print $1}')
  docker exec -it $containerid bash
}

docker_prune() {
  docker stop $(docker ps -a -q) yes 
  docker system prune -a
}


aws_ssh() {
  instancePublicIp="$(ec2_instance_public_ip)"
  xdotool key shift+F10 r 2
  ssh -i ~/.ssh/codely.pem ubuntu@$instancePublicIp
}

ec2_instance_public_ip() {
  local ip=$(aws ec2 describe-instances --output text --filters "Name=tag:Name,Values=*" --query "Reservations[*].Instances[*].{IP:PublicIpAddress,Name:Tags[?Key=='Name']|[0].Value}" | fzf | awk '{print $1}')
  echo "$ip"
}

trobbit_start(){
	gnome-terminal --tab -- zsh -ic "export TITLE_DEFAULT='docker';nvm use v12.18.3;cd ~/Trobbit; docker-compose up; exec zsh;"
	gnome-terminal --tab -- zsh -ic "export TITLE_DEFAULT='Administration';nvm use v12.18.3;cd ~/Trobbit/TrobbitAdministrationService; npm run start:dev; exec zsh;"
	gnome-terminal --tab -- zsh -ic "export TITLE_DEFAULT='Operation'; nvm use v12.18.3;cd ~/Trobbit/TrobbitOperationService; npm run start:dev; exec zsh;"
	gnome-terminal --tab -- zsh -ic "export TITLE_DEFAULT='Security';nvm use v12.18.3;cd ~/Trobbit/TrobbitSecurityService; npm run start:dev; exec zsh;"
	gnome-terminal --tab -- zsh -ic "export TITLE_DEFAULT='Gateway';nvm use v12.18.3;cd ~/Trobbit/TrobbitApi; npm run start:dev; exec zsh;"
	gnome-terminal --tab -- zsh -ic "export TITLE_DEFAULT='Client';nvm use v12.18.3;cd ~/Trobbit/TrobbitClient; npm start; exec zsh;"
	gnome-terminal --tab -- zsh -ic "export TITLE_DEFAULT='Socket';nvm use v12.18.3;cd ~/Trobbit/TrobbitSocket; npm run start:dev; exec zsh;"
}



