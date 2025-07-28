sleep 1

terminal-bg --script 'printf "\e]4;7;#272727\a"; clock-rs -t -c black clock' \
  --monitor 0 --x 0 --y 10 --w 600 --h 300 &

sleep 2

terminal-bg --script 'cava' \
  --monitor 0 --x 0 --y 880 --w 1920 --h 200 &
