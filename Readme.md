# PicPic

## Import before you start testing
The unsplash apiKey is not contained into the project. You must import the plist file provided with the email. Other wise the app wont work.

## General feedback

the project was very interesting to do. I think the key challenge was the transition part. In addition to the requested I also made it interactive with a pan Gesture to dismiss. 

I add to associate quality of code along with rapidity of development. I tried as much as possible to comply with SOLID principles.

## Implementation
### UI

I used UIKit with a mic of xibs and programatic construction. 

I mostly followed the **Today*** view's mock up with my own small touches. The today dans search controllers are embedded into a bespoke tab-bar controller.

The **details controller** I chose to go a bit different path. Rather than a traditional grid like collection layout I chose to leverage the power of compositional layouts to give a more modern look. 
The layout is computed in its own class making it easy to reuse (protocols).

*For both controllers and for performance improvements I used the collectionView **prefetching** API and images are decoded and rendered on a background thread.*

Custom modal transition from today to details is off courses it own subclass of **UIViewControllerAnimatedTransitioning**. The class is quite messy (although I am not sure it is possible to do otherwise with custom transitioning in iOS) and needs refactoring.

The search controller is simple a navigation controller with a **UISearchController** embedded. Nothing happens there yet. 
### Architecture
The only design pattern I used was **delegate/protocol**. Screens manipulating sets of data (Today and details) have their own viewModels. Smaller views perform dataFetching (Image downloading) directly in classes. I thought it would be overkill to go down the road of full MVVM or MVP or even VIPER. 

For **navigation** I think it would be a good thing to implement coordinators especially if, later, the search controller yields pictures we want to see the details of. For now it is plain UIKit navigation logic (Ok with the size of the project for the time being).

**Networking** is composed of a main networking layer solely responsible for effectively calling the network. There is a more detailed layer of networking which is specialized and can call specific routes. 
It is easy to create new routes with the WebEntry protocol which provides the minium configuration for the entry to be used in the main networking layer. 
I chose to features these two layers so that first the least specialized can be easily replaced be a library (Alamofire for instance) and secondly because that way if respects the inversion of dependance principle. 

**Images networking** is performed has its own class. It manages caching and image rendering on a ***background thread for performance***. If i have had more time I would have also created an abstraction layer here for scaling. (Yet I believe URLSession - with a little bit of help- can take a project quite far even In terms of image networking. )

### Data

The model is very simple. I converted network endpoint into structs. I chose a Struct approach rather than a Class because user don't interact with the model and therefore not update is necessary and furthermore no propagation of changes. 

I made good use of delegates here of limit the fat interface effect. That way **DetailCell** for instance is only exposed to what it needs.

## What next
A lot of things can be improved obviously. 

I am not yet satisfied with the look and feel of the modal transition. Moreover the code also needs refactoring.

**Testing** is not present and I would have make a greater use of those especially for a production app. Yet with the current architecture it would be quite easy to test 80 to 90 percent of the app's code base. 

Improve **error handling**. For now it is only a retry logic and the error message can be very unclear.

I would probably **get rid of xibs** and use a framework to build the UI as the app scales. 

The image downloading class could use some refactoring.

Improve comments on especially generic methods.
