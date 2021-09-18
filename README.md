
![Logo](./assets/images/biasbs.png)

    

# IASBS BigBlueButton Document

This is a technical private document for manipulating BigBlueButton in the IASBS-CC.

## Before you start

BigBlueButton system contains two high-level modules:
- **BigBlueButton Server Side**: This module is the core of the system and contains several software packs, such as Nginx, bbb-core, bbb-api, bbb-record, bbb-web, bbb-html5 and etc. The class environments and all inner events, e.g. recording, voice chat, text chat and presentation, are performed on this module.
- **User Endpoint Interface**: This is a user-friendly interface that the community developed for themselves. It interacts with bbb-api to start and end a class on bbb-web. This type of packs can include other functionality such as user management, recordings list, and class persistent link generation (BBB can not detect the classes after the end and it starts any class independent of history). For using the admin panel there is Ruby-based web software, GreenLight, which is developing by the BBB community. For other purposes, there are a lot of extensions, that can be installed on other Learning Management Systems (LMS) like Moodle, WordPress, Joomla and etc.
Also, anyone can develop their own interface based on their required features.

A standard BigBlueButton installation provides all required software of both modules, embedded together, in a server. But based on IASBS online learning requirements, we have separated the two modules to expand the system to large scales.



## Before you install

We are installing BigBlueButton with a **clean** and **dedicated** Ubuntu 18.04 64-bit server with no prior software installed. 

- A **clean** server does not have any previous web applications installed (such as plesk, webadmin, or apache) that are binding to port 80/443.
- By **dedicated** we mean that this server won’t be used for anything else besides BigBlueButton (and possibly BigBlueButton-related applications such as Greenlight).



### Network Requirements


###


bash bbb-install.sh -v bionic-240 -s elearn2.iasbs.ac.ir -e elearn@iasbs.ac.ir -w -g
