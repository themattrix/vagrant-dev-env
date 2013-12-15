### My (Continuously Evolving) Linux Development Environment

> Status
>
> - Ubuntu: **Operational**
> - CentOS: *Not yet ready for use.*

#### Initial Setup

1. Fork this repo.
2. Fork [this home repo](https://github.com/themattrix/home).
3. Clone this repo and change the variables in `provisioning/ansible/config/hosts` to match your repo, name, and email.
4. Create a `.data/ssh` directory in the clone of this repo.
5. Create an ssh `config` file in the `.data/ssh` directory. This should point to the private key of your forked "home" repo. My `config` looks like this:

```
Host github.com
     User git
     IdentityFile ~/.ssh/github
     PubKeyAuthentication yes
     PasswordAuthentication no
     KbdInteractiveAuthentication no
     PreferredAuthentications publickey
```

6. Create a `keys` directory in `.data/ssh` and copy your github key into it. In the example above, my key is named `github`. My `.data` directory looks like this:

```
.data/
    ssh/
        config
    keys/
        github
```

#### Usage

1. In your clone of this repo, run:

```
$ vagrant up ubuntu
```

2. Wait while Vagrant downloads the image and provisions the machine. Then run:

```
$ vagrant ssh ubuntu
```

That's it!
