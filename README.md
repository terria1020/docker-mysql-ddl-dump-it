## Docker-MySQL-DDL-Dump-It

개발용 MySQL 서버의 Scheme(DDL만)을 로컬의 mysql로 옮기자

## QuickStart

### dependency

`Docker`이 설치되어 있어야 함

`Docker compose`를 실행할 수 있어야 함

### file structure

dump-and-server: ddl을 dump하고 mysql을 실행

dump-and-server/dockerfile: Dockerfile이 담김

dump-and-server/dockerfile/script: Dockerfile이 실행하는 스크립트가 담김

only-server: mysql만을 실행(DDL dump가 필요 없을 때)

### env file setting

> 반드시 실행 전 env 파일을 세팅하여야 함

---

**_dump-and-server:_**

MYSQL_ROOT_PASSWORD=toor -> 로컬에 실행할 MySQL의 비밀번호

ORG_HOST=your.server.host.here -> 개발 서버의 mysql host 주소

ORG_USER=your.server.mysql.user.here -> 개발 서버의 mysql user

ORG_PASSWORD=your.server.mysql.password.here -> 개발 서버의 mysql password

ORG_DB=your.database.here -> 개발 서버의 mysql database(schema)

MYSQL_SERVICENAME=mysql -> docker-compose 서비스명이므로 고정

MY_PORT=3306 -> 로컬에 실행할 MySQL의 외부 포트

## WAIT=30 -> 로컬에 실행할 mysql의 initialize가 시간이 좀 걸리므로 dump-덮어쓰기 작업 전에 기다리는 시간

**_only-server:_**

MYSQL_ROOT_PASSWORD=toor -> 로컬에 실행할 MySQL의 비밀번호

MY_PORT=3306 -> 로컬에 실행할 MySQL의 외부 포트

### mysql server scheme into my local

1. set `dump-and-server/.env` file
2. open Terminal

```shell
cd dump-and-server
docker compose up -d --build
```

3. wait until `docker ps` don't show ubuntu container
4. connect local mysql

### no dump, only server on

1. set `only-server/.env` file
2. open Terminal

```shell
cd only-server
docker compose up -d
```

3. connect local mysql

### use shellscript

-   server on:

```shell
cd script/
bash dump-and-server-start.sh
or
bash server-only-start.sh
```

-   server off:

```shell
cd script/
bash dump-and-server-stop.sh
or
bash server-only-stop.sh
```

## Docker compose 환경을 구상한 이유

서버의 mysql connection을 잡아먹는 것도 그렇고, 잘못 건드려서 뭐가 날아갈 수 있을 것 같은 상황이 있을수도 있다고 생각하여 로컬의 mysql에 schema를 가져오는 것을 구상하게 되었음

## dump 실행 절차

0. Dockerfile build
1. 로컬에 사용할 mysql 서비스 시작
2. dump에 사용할 ubuntu 시작
3. mysql 서비스가 initialize 되는 동안 $WAIT초만큼 기다림
4. 개발 서버에 mysqldump로 접속하여 hot dump 실행 및 저장
5. mysql 서비스에 dump 한 DDL sql문으로 데이터베이스 복원
