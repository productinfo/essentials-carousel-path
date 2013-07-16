ShinobiEssentials Conveyor Belt Carousel (Objective-C)
=====================

This project demonstrates how to build a custom Carousel which imitates a conveyor belt, and attempts to reproduce the effect of the iOS7 Safari tabs screen (which you can see in action [here](http://www.apple.com/ios/ios7/)). There's an accompanying [blog post](http://www.shinobicontrols.com/blog/posts/2013/07/15/customizing-your-carousel-path/) explaining how the custom carousel path works. 

![Screenshot](screenshot.png?raw=true)

Building the project
------------------

In order to build this project you'll need a copy of ShinobiEssentials. If you don't have it yet, you can download a free trial from the [ShinobiEssentials website](http://www.shinobicontrols.com/shinobiessentials/).

Once you've downloaded and unzipped ShinobiEssentials, open up the project in Xcode, and drag ShinobiEssentials.embeddedframework from the finder into Xcode's 'frameworks' group, and Xcode will sort out all the header and linker paths for you.

If you’re using the trial version you’ll need to add your license key. To do so, open up AppDelegate.m, import <ShinobiEssentials/SEssentials.h>, and set the license key inside application:didFinishLaunchingWithOptions: as follows:

    #import <ShinobiEssentials/SEssentials.h>

    @implementation AppDelegate

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        [SEssentials setLicenseKey:@"your license key"];
        …
    }

Contributing
------------

We'd love to see your contributions to this project - please go ahead and fork it and send us a pull request when you're done! Or if you have a new project you think we should include here, email info@shinobicontrols.com to tell us about it.

License
-------

The [Apache License, Version 2.0](license.txt) applies to everything in this repository, and will apply to any user contributions.

