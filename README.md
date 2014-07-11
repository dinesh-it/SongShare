SongShare
=========

Simple web app using perl CGI and html,javascripts to share/stream all of your Songs in your Songs directory in your local network.

view
----

This directory will contain all html,css and javascript files. This is the Root directory(DirectoryRoot) of my apache server.

cgi-bin
-------

This directory will contain all the perl CGI scripts. 

This is the configuration for apache
------------------------------------

```
DocumentRoot /SongShare/view/
ScriptAlias /perl/ /SongShare/cgi-bin/
Alias /SongShare/songs/ /SongsShare/view/songs/

<Directory "/home/dinesh/apache-root/cgi-bin/">
    AllowOverride None
    Options ĚxecCGI -MultiViews ŠymLinksIfOwnerMatch
    Require all granted
</Directory>

<Directory "/YourDir/Songs/">
    AllowOverride None
    Options -MultiViews ŠymLinksIfOwnerMatch
    Require all granted
</Directory>
```

License
-------

This is a simple html file and perl scripts with some basic configuration in apache. Its purely open source anybody can reuse it if really neede :).
