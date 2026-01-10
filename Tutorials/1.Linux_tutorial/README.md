# Linux Tutorial

## Linux
- Linux is a family of open-source Unix-like operating systems.
- The Linux kernel was released by Linus Torvalds in 1991.
- Provided under the GNU General Public License.
- Originally developed to provide a Unix experience for personal computers based on x86 Currently ported to more platforms than any other OS.
- Android is based on Linux.
- Linux is usually packaged as a distribution or “Distro” Red Hat, Fedora, Ubunto, CentOS, SUSE, others
- Commonly distributed with windowing system and 	desktop environment (e.g., GNOME, KDE)

## The Bash Shell

- Your interface into the operating system is the “shell
    - Allows you to run programs
    - Give input to programs
    - Inspect the output of programs

- The “Bourne Again Shell” (bash) is the most popular Linux shell today.
- We will first open a “terminal”.
- This will provide us with a “prompt”

    ```bash
    /foss/designs > 
    ```

## Hello, World!
- Every programming course starts with a “Hello, World!”
    - To tell bash to print “Hello, World!”, we’ll use the command echo:

        ```bash
        /foss/designs >  echo 'hello, World!'
        ```

    - echo is the name of the program and ‘Hello, World!’ is the argument.
    - We can run other programs, try, for example, date:

## Paths

- **How does the shell know how to find the `date` or `echo` programs?**
    - It searches through a *list of locations on the file server*.
- **Where is this list stored?**
    - In an *environment variable* called `PATH`.
- **To dereference a variable, we will use the `$` character:**

    ```bash
    /foss/designs > echo $PATH
    ```

    - We got a list of locations on the server, which are used to *search for programs.*
- **But where did it find the `echo` and `date` programs?**

    ```bash
    /foss/designs > which date
    ```
    - We see that these are executable files stored in the **`/bin (=binaries)`** folder
    - Alternatively, we could have run: 
        ```bash
        /foss/designs > /bin/echo 'Hello, World!'
        ```

## Navigation in the Shell

- **So we saw that there are “locations” in the Linux environment**
    - `/` is the `“root”` of the filesystem, under which all directories and files lie.
    - `~` is your `“home”` directory, but this is an alias.
    - To see what the real path to your home directory is:

    ```bash
    /foss/designs > pwd
    ```

    ```bash
    /foss/designs > echo $HOME
    ```

    - `pwd` is short for `“print working directory”` – that’s “where we are” now

- **We can navigate through directories with `cd` (change directory)**  

    ```bash
    /foss/designs > cd ..
    /foss/designs > ./juancho
    ```

- **`.` is the `“current”` directory, while `..` is the `“parent”` directory**
