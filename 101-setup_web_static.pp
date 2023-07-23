# puppet to install nginx and configure it to serve some content
exec {'update':
path     => '/usr/bin',
command  => 'sudo apt-get -y update',
provider => 'shell',
}
->
package { 'apache2.2-common':
ensure => absent,
}
->
package { 'nginx':
ensure  => installed,
require => Package['apache2.2-common'],
}
->
service { 'nginx':
ensure  => running,
require => Package['nginx'],
}
->
file { '/data/':
ensure => 'directory',
}
->
file { '/data/web_static/':
ensure => 'directory',
}
->
file { '/data/web_static/shared/':
ensure => 'directory',
}
->
file { '/data/web_static/releases/':
ensure => 'directory',
}
->
file { '/data/web_static/releases/test/':
ensure => 'directory',
}
->
exec {'html file':
path     => ['/usr/bin', '/bin'],
command  => 'sudo touch /data/web_static/releases/test/index.html',
provider => 'shell',
}
->
exec {'write html':
path     => ['/usr/bin', '/bin'],
command  => 'sudo echo  "Holberton School" > /data/web_static/releases/test/index.html',
provider => 'shell',
}
->
exec {'symlink':
path     => ['/usr/bin', '/bin'],
command  => 'sudo ln -sf /data/web_static/releases/test/ /data/web_static/current',
provider => 'shell',
}
->
exec {'chown':
path     => ['/usr/bin', '/bin'],
command  => 'sudo chown -R ubuntu:ubuntu /data/',
provider => 'shell',
}
->
exec {'config':
path     => ['/usr/bin', '/bin'],
# lint:ignore:140chars
command  => 'myc="\n\tlocation \/hbnb_static\/ {\n\t\talias \/data\/web_static\/current\/\;\n\t}\n"; st="server {"; sudo sed -i "s/^$st/$st$myc/" /etc/nginx/sites-enabled/default',
# lint:endignore
provider => 'shell',
}
->
exec {'start nginx':
path     => ['/usr/bin', '/bin', '/usr/sbin/'],
command  => 'sudo service nginx start',
provider => 'shell',
}
