#!/usr/bin/env ruby
require_relative 'which'
require_relative 'PkgMgrs'


args=ARGV
argsShift=[]

for i in args do
  argsShift.push(i)
end

argsShift.shift

for i in argsShift do
  pkgArgs = "#{pkgArgs} #{i}"
end

#package managers to check for
pkgMgrs = ["#{$debianBased}",
            "#{$archLinux}",
            "#{$voidLinux}"]

#iterate over list of package managers
#pass this to which(), take result and set it to pkgMgr
for i in pkgMgrs do
  if which(i) then
    pkgMgr=i
    break
  end
end

# since some package managers have hyphens
# and since methods can't have hyphens,
# we take out any existing hyphens and replace them with underscores
pkgMgr = pkgMgr.tr('-', '_')

# check for and execute methods with the same name as pkgMgr contains
send(pkgMgr)


#pull variables from currently loaded method, e.g pacman()
install = "#{$installCmd} #{pkgArgs}"
reinstall = "#{$reinstallCmd} #{pkgArgs}"
search = "#{$searchCmd} #{pkgArgs}"
update = "#{$updateCmd} #{pkgArgs}"
remove = "#{$removeCmd} #{pkgArgs}"
force_remove = "#{$recursiveRemoveCmd} #{pkgArgs}"
sync = "#{$syncCmd} #{pkgArgs}"
supdate = "#{$syncANDupdateCmd} #{pkgArgs}"
clean = "#{$cleanCmd}"



case args[0]

# Install Options
when
  "i",
  "-i",
  "-S",
  "add",
  "get",
  "install";  system ("sudo #{install}")

when
  "ri",
  "-ri",
  "reinstall"; system ("sudo #{reinstall}")


# Search options
when
  "s",
  "se",
  "-s",
  "-Ss",
  "find",
  "search";  system (search)

# Update options (without syncing)
when
  "u",
  "up",
  "-u",
  "-Su",
  "upgrade";  system ("sudo #{update}")

# Remove options
when
  "r",
  "rm",
  "-R",
  "remove",
  "delete";  system ("sudo #{remove}")

when
  "-rf",
  "-Rdd",
  "force-remove"; system ("sudo #{force_remove}")

when
  "c",
  "-c",
  "clean"; system ("sudo #{clean}")

# Sync options
when
  "sy",
  "-Sy",
  "sync",
  "refresh";  system ("sudo #{sync}")

# Update options (with syncing)
when
  "su",
  "sup",
  "-Syu",
  "syncup";  system ("sudo #{supdate}")

when
  "-v",
  "--version"; puts """

  tux v0.1 - Universal package manager wrapper
  \u00A9 2015 Justin Moore
  """

else
  puts """
  Usage : tux [options] [arguments]

  Options:

  i, -S, install        Install a package
  ri, -ri, reinstall    Reinstall a package
  r, -R, remove         Remove a package
  c, -c, clean          Remove orphan packages
  s, -Ss, search        Search remote repository
  sy, -Sy, sync         Sync package list from remote repository
  u, -Su, upgrade       Upgrade packages on the system
  su, -Syu, sup         Sync package list and upgrade system
  -v, --version         Show current version


  """

end
