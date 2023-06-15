#!/bin/bash

#При первом запуске создаётся снапшот целевой папки на удалённом сервере
#При последующем - очередной бэкап, с опцией --link-dest=snapshot_folder, таким образом в папке бэкапа совпадающие со снапшотом файлы являются жесткими ссылками (hard link) и не занимают место на жестком диске
#В случае, если бэкапов становится более 5, происходит слияние самого первого бэкапа со снапшотом, после чего создаётся очередной бэкап, как в предыдущем пункте.
#И снапшот, и бэкапы хранятся на удаленном сервере, поэтому для возможности их слияния на нём должен быть установлен rsync

# Параметры скрипта
SOURCE_DIR="/home/night"
REMOTE_HOST="root@192.168.100.10"
REMOTE_DIR="/backup_server1"
SNAPSHOT_NAME="snapshot"
BACKUP_PREFIX="backup"
MAX_BACKUPS=5

# Функция для создания снапшота
create_snapshot() {
  rsync -a --delete "$SOURCE_DIR/" "$REMOTE_HOST:$REMOTE_DIR/$SNAPSHOT_NAME"
}

# Проверяем создана ли директория в которую будут записаны бэкапы и снапшот
ssh "$REMOTE_HOST" "test -d $REMOTE_DIR/ || mkdir -p $REMOTE_DIR "

# Функция для создания инкрементного бэкапа.
# В rsync указываем снапшот на удаленном сервере в качестве референсной директории.
# Создаём очередной бэкап c датой и временем в имени, в дальнейшем получить имя самого нового или 
# самого старого бэкапа можно просто выполнив ls [-r] | grep backup | tail -1
create_backup() {
  new_backup_name="${BACKUP_PREFIX}_$(date +%Y-%m-%d_%H:%M:%S)"
  rsync -a --link-dest="$REMOTE_DIR/$SNAPSHOT_NAME" --delete  "$SOURCE_DIR/" "$REMOTE_HOST:$REMOTE_DIR/$new_backup_name"
}

# Функция для объединения самого первого бэкапа со снапшотом и его последующего удаления.
# Rsync выполняется на удаленном сервере через подключение ssh, т.к. невозможно указать одновременно удаленный сервер в исходном файле и файле назначения
merge_backup_with_snapshot() {
  oldest_backup=$(ssh "$REMOTE_HOST" "ls -r $REMOTE_DIR/ | grep $BACKUP_PREFIX | tail -1")
  ssh "$REMOTE_HOST" "rsync -a --delete $REMOTE_DIR/$oldest_backup/ $REMOTE_DIR/$SNAPSHOT_NAME"
  ssh "$REMOTE_HOST" "rm -rf $REMOTE_DIR/$oldest_backup"
}


# Основная часть скрипта. Проверяем есть ли снапшот. Если нет, то создаём его, если есть, то записываем очередной по счету бэкап.
# Если бэкапов больше 5, то объединяем самый первый бэкап со снапшотом и пишем следующий
if ssh "$REMOTE_HOST" "test -d $REMOTE_DIR/$SNAPSHOT_NAME"; then
  num_backups=$(ssh "$REMOTE_HOST" "find $REMOTE_DIR -mindepth 1 -maxdepth 1 -name '$BACKUP_PREFIX*' -type d | grep -v '^$' | wc -l")
  if [ "$num_backups" -ge "$MAX_BACKUPS" ]; then
    merge_backup_with_snapshot
    num_backups=$(( num_backups - 1 ))
  fi
  create_backup
  num_backups=$(( num_backups + 1 ))
  echo "Создан очередной бэкап. Общее количество бэкапов - $num_backups"
else
  create_snapshot
  echo "Создан снапшот директории"
fi