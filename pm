#!/bin/bash
#     This file is part of quickpass, a Passwords Generater and Password Manager 
# Copyright (c) 2016 ali abdul ghani <alimiracle@riseup.net>
# Copyright (c) 2016 ali abdul ghani <alimiracle@riseup.net>
#     quickpass is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
# (at your option)    any later version.
#    quickpass is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#    You should have received a copy of the GNU General Public License
#    along with quickpass.  If not, see <http://www.gnu.org/licenses/>.
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi
user_name=`whoami`
encrypt() {
if test $# = 0
then
echo E:Missing Website name
exit
fi
if test $# = 1
then
echo E:Missing  password
exit
fi
if test $# = 2
then
echo E:Missing gpg key
exit
fi
echo $2 | gpg --encrypt --armor -r $3 > /$user_name/.pm/$1
}
decrypt() {
    file=`ls /$user_name/.pm`
    if echo "$file" | grep -q $1; then
cat /$user_name/.pm/$1 | gpg --decrypt -r $2
    else
    echo I cant find the web site name
exit
    fi
if test $# = 1
then
echo E:Missing gpg key
exit
fi

}
remove() {
    file=`ls /$user_name/.pm`
    if echo "$file" | grep -q $1; then
rm /$user_name/.pm/$1
else
    echo I cant find the web site name
exit
    fi
}
    tistdir=`ls -a /$user_name`
    if echo "$tistdir" | grep -q ".pm"; then
echo
else
mkdir /$user_name/.pm
fi
if test $# = 0
then
echo E:Missing Website name
exit
elif test "$1" = "--new"
then
encrypt $2 $3  $4
exit
elif test "$1" = "--list"
then
ls /$user_name/.pm
exit
elif test "$1" = "--remove"
then
remove $2
exit
fi
decrypt $1 $2
