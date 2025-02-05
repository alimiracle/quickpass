# Quickly generate strong random passwords #

With **quickpass**, you can quickly and easily generate strong passwords from the comfort of your terminal using nothing more than just a few common Unix command line utilities and device blocks. Here's how to use it:

To generate a single, 32-character random password, just type:

    $ ./quickpass
    # Password gets copied to clipboard e.g.: !RM*U<AN#YI:%yQiR<L<:&q+?:Luq@6'

To generate a random password specifically with 42 characters in length, type:

    $ ./quickpass -l 42
    # Password gets copied to clipboard, e.g.: Y{@u&EzY\,@SOi^w,0r=gTr3V_-H|3Hk=)9g!aRfJL

If you want to use `quickpass` to create passwords on-the-fly along another script, pass the `-p` flag, which forces the script to print the output to stdout, where you can pipe or store it as needed:

    # naive usage, prints to terminal where everyone can read
    $ ./quickpass -p
    PG=6>%^v$5,Tb3Es"'v+_b"d63@dn'`;
    
    # encrypt the password as soon as you generate it:
    $ ./quickpass -l 40 -p | gpg --armor --encrypt -r somebody@example.com
    
    # store the password in a variable in memory:
    $ key=$(./quickpass -p)

# Technical explanation and a note about security #

`quickpass` is a very simple implementation of translating a sampling of random bytes from the `/dev/urandom` device with `tr` turning them into something that is human-readable and therefore applicable to be used as a password.

The reliability of this script lays mostly on the quality of the randomness obtained from the `urandom` file: it should be noted that, despite its name, it's actually a *pseudorandom* generator (although it samples hardware noise to compensate). 

This means that from a strict security standpoint, this is **not** a true random generator, although it's pretty good regardless. OpenSSL certs and PGP keys are also generated using those bits, so I guess it should be pretty reliable.

Finally, remember that this is **not** a password *manager* - i.e. no support for securely storing and retrieving the random password. You could do something like this to produce a plausibly-deniable zero-knowledge storage that you can read later on:

    $ ./quickpass -p | gpg --armor --encrypt -r yourkey@example.com > password.asc

Remember, though, that I'm not a security expert and therefore this implementation could have its own weaknesses as well.

## Entropy analysis and password strength ##

This [excellent article](https://pthree.org/2014/03/16/creating-strong-passwords-without-a-computer-part-0-understanding-entropy/) by Aaron Toponce gives a good basis from which password strength can be measured: information **entropy**. Entropy for a password can be calculated like this:

    H = L * log(N)/log(2)

Where `L` is the length in characters and `N` is the number of possibilities that a single character can be in the password. `quickpass` generates passwords with all printable ASCII characters (95) with roughly the same probability of appearing (about 1.05%), which gives us a per-character entropy of 6.57 bits, but how much do we need?

Aaron gives us the answer again: any password with less than 72 bits of entropy can be brute-forced by the Bitcoin Blockchain in **less than a minute**, making his recommendation of 80 or more bits. The standard 32-character password generated by `quickpass` has an entropy of 210 bits, so you should be pretty safe.

Remember, however, that for some weird reason a few online services put a cap on how long a password can be, forcing you to use less secure passwords. Although you can easily change that using the `-l` option, remember to stay above the 80 bit threshold, which for `quickpass` would be 14 characters.  Anything less, and you're as vulnerable as picking passwords like `monkey`.

# Changelog #

 - v0.1 - first usable version: uses `base64` to produce printable characters
 - v0.2 - from a suggestion by [@cmd](https://diasporabr.com.br/people/b1b87950852001325d4e4860008dbc6c) it now uses `tr` to produce all printable ASCII characters for a much stronger password!
 - v0.3 - from a suggestion by [@muja](https://notabug.org/muja) the script now uses the xsel command (if available) to copy the password to the clipboard instead of printing it out.
 - v0.4 - enabled the `-p` flag which overrides the copying to clipboard. `quickpass` should be much more useful to deploy in shell scripts now. Also, password list creation has been removed, since passwords gets piped away from stdout by default.

