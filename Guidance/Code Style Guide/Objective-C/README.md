#Ordnance Survey Objective-C Code Style Guidelines

The aim of this document is to ensure a consistent style guide across our code base, to better promote readability and make it easier to spot potential problems within the code base. These guidelines were agreed by the team, and based off of common industry standards as well as other code style guides (such as [GitHub's](https://github.com/github/objective-c-style-guide), [The New York Times'](https://github.com/NYTimes/objective-c-style-guide) and [Google's](http://google-styleguide.googlecode.com/svn/trunk/objcguide.xml)). Assume Apple's own guidelines also apply unless stated otherwise.

##1. Consistent Code Base
We use [clang-format](http://clang.llvm.org/docs/ClangFormat.html) to ensure consistency across our code base, specifically using the attached [config file](.clang-format). There is an Xcode plugin available for clang-format available [here](https://github.com/travisjeffery/ClangFormat-Xcode), which can also be installed using [Alcatraz](http://alcatraz.io/). Once installed, simply save the .clang-format file to your HOME directory, or commit it within the project's directory, then in the Edit->Clang Format menu in Xcode choose File, and then choose Enable Format on Save.

Due to changes in clang-format 3.7 that we didn't like, we have a custom build of clang-format in this repository that allows us to format blocks in the way specified in this document. It is available in this repository, [here](clang-format). To use it in the Xcode plugin, copy it to ~/Library/Application Support/Developer/Shared/Xcode/Plug-ins/ClangFormat.xcplugin/Contents/Resources.

##2. Line Length
Our clang format configuration doesn't specify a hard line length. Try to keep the line length reasonable, but also bear in mind we all have large screens. No line should need to be scrolled to be read.

##3. Blocks
Clang format can be a little inconsistent about formatting blocks, so pay some attention to how they're formatted. Try to be consistent with the rest of our common style if clang format won't do what you want.

For example, prefer:

    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        view.hidden = YES;
    }];

over

    [UIView animateWithDuration:0.3
                     animations:^{
	                     view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
	                     view.hidden = YES;
                     }];

Clang format currently doesn't do a great job of formatting code within a block, so blocks should be checked for formatting style to ensure they're consistent with the code base. Select the text and use Edit->Clang Format->Format Selected Text if necessary.

##4. Comments
Code should be commented.

No need to comment everything, but groups of information, complex business logic, work around reasons and general useful stuff should be added. Write like you are handing over your code to another developer. Play Nice!

Document _why_, design decisions behind the code rather than what the code does. If you find yourself needing to document what, your code probably needs to be refactored.

All public interfaces should be documented with Javadoc style comments. This should include class, property, method and function definitions, and where appropriate, parameter and return types. In those circumstances, document caveats around the behaviour. Should a parameter be non-null or a method return null if something fails? Is the parameter a dictionary that is expecting some specific keys?
There is an Xcode plugin called [VVDocumenter](https://github.com/onevcat/VVDocumenter-Xcode) to take a lot of the chore factor out of formatting, installable via [Alcatraz](http://alcatraz.io/).

##5. Unit Testing
Code should be accompanied with a suitable level of unit testing. Ensure you are aware of the expected level and targets of code coverage before you start working on a project. As a minimum, Ordnance Survey expects around 80% code coverage. Style guide and expectations for testing will be documented separately.

### Notes on testing performance
Unit test code should be written to be as performant as possible. Remember your code is likely to be running on a VM and will have resource limitations. The more performant your code, the quicker your builds will pass and the less likely you will be to have phantom test failures. Following these guidelines can help you keep your tests fast.
* Avoid asynchronous tests where possible. Particularly in a large test suite, asynchronous tests open you up to potential outside affects caused by waiting for the run loop.
* Keep autorelease pools in mind. It seems that XCTest will run tests in a fairly tight loop, meaning that any objects added to an autorelease pool may not get deallocated. Avoid adding large pieces of data to an autorelease pool where possible.
* Split tests in to separate test classes, most likely representing functional areas of the class under test. This seems to split them in to separate runs of the loop, allowing the pool to drain. This will also likely help you understand whether you're adhering to SRP and whether your class under test needs refactoring.
* Only add things to the class `setUp` method if it truly applies to all the tests in the test case. Otherwise, it's probably better to explicitly set up and tear down those dependencies in the test case. Consider if this is also a code smell to further split either your tests or your target class.
* For a specific example, some UI tests may require your view controller to be in a `UIWindow` hierarchy. In this situation, make sure only those specific tests have a window. When a window is released it adds its `rootViewController` to an autorelease pool, which can leave large amounts of memory being used.
* If using MIQTestingFramework, ensure you're using the latest version, which has some memory leak fixes in expecta, specta and OCMock.

##6. Test code on multiple simulators
Where appropriate, ensure your code works as expected on all devices. Include results in your pull request. For changes in UI, include screenshots.

##7. Treat compiler warnings like errors
Pull requests that generate compiler warnings will be rejected.

##8. Static Analysis
All code should be run through the static analyser during the unit testing build process. Any issues will cause that build to fail and prevent your pull request from being merged. Ensure all analyser warnings are fixed before creating your pull request.

##9. Branching
For an app project, where the work is done in sprints and the end result is submitted to apple for review, please follow the [git flow branching model](http://nvie.com/posts/a-successful-git-branching-model/). All work should be done on feature branches branched from `develop` and merged back there after review. When releasing to the app store, the `develop` branch should then be merged to `master` and tagged. Make use of `hotfix` and `release` branches where appropriate, as described by git flow.

For library projects, simply use feature branches from master to work. Each merge back to master should be accompanied by a new version number, as described by [semantic versioning](http://semver.org/). Ensure the new version number is appropriate for the change made and agreed by the reviewer.

##10. Pull requests
All code should be peer reviewed before being merged to the main branch. Open a pull request on github. This should trigger a build of your branch on circleci.com. No pull request should be merged without a passing test build. Preferably, a pull request should be reviewed by two reviewers. Allow the reviewers to merge your pull request. Delete all unused branches from github after merging.

The other developer should checkout, build (check for warnings/errors) and test the feature (including any layout changes) on a real device. Results of the test should be posted in the pull request by the other developer.

Keep pull requests small and focused. Try to keep it to not more than 200 lines of code, in small, logical chunks. If your feature isn't ready to be merged back in to the main branch, branch from your feature branch and make pull requests back to your feature branch. Some useful advice can be found [here](http://www.pushing-pixels.org/2015/06/11/code-spiral.html)

##11. Breaking retain cycles in blocks
Blocks can result in retain cycles and memory leaks if some variables are strongly captured within the block. For example

    @interface OSObject : NSObject

    @property (copy) void (^block)(void);

    @end

    @implementation OSObject

    - (void)muchBadness {
        self.block = ^{
            NSLog(@”%@”, self); // Self is captured and leads to a retain cycle
        };
    }

    @end

will result in a retain cycle when `muchBadness` is called. For this reason, there are two macros available, `OSDeclareWeak` and `OSRedeclareStrong` that should be used as below. `OSRedeclareStrong` should always be used to ensure the weak variable lives for the duration of the block to avoid any potential data corruption.

    @interface OSObject : NSObject

    @property (copy) void (^block)(void);

    @end

    @implementation OSObject

    - (void)muchBadness {
        OSDeclareWeak(self);
        self.block = ^{
            OSRedeclareStrong(self);
            NSLog(@”%@”, self);
        };
    }

    @end

The macros, if not already available in your project, are:

    #define OSDeclareWeak(x) __weak __typeof(x) _dontusemeim_weak_ ## x = x
    #define OSRedeclareStrong(x) __strong __typeof(x) x = _dontusemeim_weak_ ## x

##12. Concurrency
Do not block the main thread. Ensure all long running tasks are moved to background queues. Use `NSOperation` / `NSOperationQueue` and gcd rather than `NSThread`.

Remember starting a thread has its own overhead, so retain the queues you're using for reuse where appropriate. Concurrency also has a significant complexity overhead. Use the main queue until performance requires you to move things. Concurrency leads to complications which may not be required. Write code such that all code that leads to background operations is initiated on the main thread and returns values on the main thread. Keep all concurrency encapsulated.

Never fetch a network resource on the main queue. File IO reads and writes are also a likely candidate for being asynchronous, especially if the file is a reasonable size.

Core Data is not thread safe. Do not pass `NSManagedObjects` between threads. Use the `performBlock:` methods with a context that has a `NSPrivateQueueConcurrencyType`.

Ensure any communication between threads is done safely. KVO is unlikely to be the best way to communicate changes between threads.

##13. `NSNotificationCenter` vs KVO vs Delegates
Use the appropriate pattern for your use case.

Use the delegate pattern when it is appropriate for a single channel of communication. A table view notifying a view controller that it has been tapped is a sensible use of the pattern.

Use `NSNotificationCenter` for broadcast type communication. A singleton object notifying that it has finished executing an operation is a sensible use case. When using `NSNotificationCenter` be sure to remove observations correctly. Consider using the helper classes available in the code base to make this easy, such as [`DHNotificationStore`](http://dhardiman.github.io/DHFoundation/documentation/Classes/DHNotificationStore.html) in [DHFoundation](http://dhardiman.github.io/DHFoundation/). Ensure you match adding observers with removing observers and make sure they occur in the correct place within your object lifecycle. For example a view controller would be sensible to add observers in `viewWillAppear:` and remove them in `viewDidDisappear:`.

Use KVO when it's sensible to observe specific changes to a model object. For example binding a text field to the value of a model object so you can update to the new value if it's changed by another operation. Ensure to remove observers correctly. Be careful of thread safety with KVO. Be aware that [UIKit is not KVO compliant](https://developer.apple.com/library/ios/documentation/general/conceptual/DevPedia-CocoaCore/KVO.html), so do not rely on KVO for UIKit classes.

##14. Properties vs manual get/set methods
Always use automatic synthesis wherever possible.

Avoid direct access to the ivar, with the exception of in custom accessors, init or dealloc methods. This follows Apple's [guidelines](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/MemoryMgmt/Articles/mmPractical.html#//apple_ref/doc/uid/TP40004447-SW6), but further info is available [here](http://stackoverflow.com/questions/8056188/should-i-refer-to-self-property-in-the-init-method-with-arc) and [here](https://www.mikeash.com/pyblog/friday-qa-2009-11-27-using-accessors-in-init-and-dealloc.html).

##15. Model View Controller Design Patterns
Use the pattern correctly. Views talking to views is likely suggesting you need to refactor. Massive View Controller problem is likely suggesting you need to refactor.

##16. Singletons
Consider whether you really need to use singletons. Where the pattern is appropriate, use the following thread-safe approach to instantiating a shared instance.

    + (instancetype)instance {
        static dispatch_once_t pred;
        static id sharedInstance = nil;

        dispatch_once(&pred, ^{
            sharedInstance = [[self alloc] init];
        });

        return sharedInstance;
    }

##17. #pragma mark Comments
Group your methods into logical groupings, depending on their functionality. For example View Lifecycle, conformance to a protocol, or specific functionality. Consider whether breaking out functionality to a new class or category might be more appropriate than a simple `#pragma mark` comment.

##18. IBOutlet Variables
In general, these should be defined weak and setup within a class extension in the implementation file, unless there is a good reason to make them public. Consider a OSClass+Private.h header if the outlets are required for unit testing.

##19. Third party libraries
New third party libraries should be agreed with Ordnance Survey and proven to work/source code audited before adding it to the project. Please do not implement the library without prior approval.

Do not use CocoaPods to install libraries. Please add libraries as dynamic frameworks. If you need to use a dependency manager, please use something non-invasive that won't cause breaking changes, like carthage. Dynamic frameworks should lower the need for a dependency manager, particularly one that can change the structure of your project.
