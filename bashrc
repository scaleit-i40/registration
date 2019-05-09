PS1="\e[0;35m[$APP_NAME] $APP_VERSION \e[0;0m\w \e[0;37m\u \h \e[0;0m\n$ "

cat <<'MSG'
 
   ____            ___          
  / __ \____  ____/ (_)_________
 / / / / __ \/ __  / / ___/ ___/
/ /_/ / / / / /_/ / / /__(__  ) 
\____/_/ /_/\__,_/_/\___/____/  
                                
(C) 2019, Ondics GmbH

MSG

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion.d/yii ]; then
    . /etc/bash_completion.d/yii
  fi                        
fi