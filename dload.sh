#!/bin/sh
#
# Скрипт для заливки загрузчика в модем, находящийся в стандартном режиме
#
# Параметр скрипта - имя порта tty, по умолчанию - /dev/ttyUSB0
#
PORT=$1
if [ -z "$PORT" ]; then PORT=/dev/ttyUSB0; fi

LDR=$2
if [ -z "$LDR" ]; then LDR=loaders/NPRG9x15p.bin; fi


echo Diagnostic port: $PORT

# Ждем появления порта в системе
while [ ! -c $PORT ]
 do
  sleep 1
 done

# команда переключения в download mode
echo entering download mode...
./qcommand -p $PORT -e -c "c 3a" >/dev/null

# Ждем пропадания порта из системы
while [ -c $PORT ]
 do
  true
 done
echo diagnostic port removed

# Ждем появления нового порта, уже download
while [ ! -c $PORT ]
 do
  sleep 1
 done

# Заливаем загрузчик
echo download mode entered
sleep 2
./qdload -t -p $PORT -i  $LDR
