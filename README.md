Amethyst Minecraft Management
---

## Requirement
1. Java 16: for running Minecraft
2. Ruby: for executive script of manage server and plugins jar files

## Structure
After set up the server, the directories structure will as following:

```
Amethyst
  configs
    spigot
      bukkit.yml
      command.yml
      spigot.yml
    vanilla
      banned-ips.json
      banned-players.json
      eula.txt
      help.txt
      ops.json
      permissions.json
      server.properties
      whitelist.json
    bottles.lock.yml
    bottles.yml
    log4j2.xml
  logs
    ....
  plugins
    ....
  scripts
    ....
  worlds
    ....
  .gitigore
  README.md
  server.jar
```

## Set Up
### Prepare: bottles directory as source
In Amethyst, it use tool `bottle` to manage current version of server and plugins jar file. Currently, it only support local registry, so we need to create a directory and put all of jar files.

To create a `bottles` directory under the grandparent directory of the project,
them put each version of server and plugin files as following. (you also can assign specific directory by edit `bottles.yml`)

```
Minecraft
  servers
    Amethyst
      ...
  bottles
    plugins
      [plugin]-[version].jar
      [plugin]-[version].jar
      [plugin]-[version].jar
    servers
      spigot-[version].jar
      spigot-[version].jar
      spigot-[version].jar
```

### Install
Copy `bottles.sample.yml` and rename to `bottles.yml`, then edit file to add/update the name and version  server and plugin list.

```sh
cd ./configs
cp bottles.sample.yml bottles.yml
vim bottles.yml

cd ../scripts
./bottles.rb
```

The script will copy the jar files mention in `bottles.yml` from `version` directory to this project.

### Start Server
If you just wanna test on local machine, you can use the `local.sh` to run the server.

```
cd ./scripts
./local.rb
```

If you wanna running on server machine, use the `start.sh` to run the server.
It will contain GC flag.

```
cd ./scripts
./server.rb
```

### Running server behind background with screen

1. Use `./starts.sh` to run the server.
2. Use `./attach.sh` to attach the server console.
3. On server console, use `ctrl+a` then `ctrl+d` to detach the console.
4. Use `./restart.sh` to restart server in 5 minutes.
5. Use `./stop.sh` to stop server in 1 minute.
6. Use `./execute "[command] [args]"` to send command into console.

## Backup
- `Configs`: you can use `git` do version control of you configs. Include:
  - configs of vanilla
  - configs of spigot
  - config of bottles (version of server and plugins)
- `Scripts`: you can customize or add more scripts to make server management easier.
- `Worlds`: just `rsync` your `worlds` directory to your backup disk or server.
- `Plugins`: just `rsync` your `plugins` directory to your backup disk or server.

## Future feature
- [ ] backup scripts
