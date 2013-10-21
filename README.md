meteor-tutorials
================

## What's this do?

Easily create super cool animated tutorials for your Meteor app. This package gives you a dirt easy way to make multi-step tutorials that spotlight multiple parts of your user interface. What a great way to show off how awesome your Meteor app is!

Here's one of my apps. Among other things, it has a list of online users (provided by the [user-status package](https://github.com/mizzao/meteor-user-status)) and a chat room. As users go through the tutorial, which has several steps, the tutorial explains different parts of the user interface to them.

![Spotlighting the user list](https://raw.github.com/mizzao/meteor-tutorials/master/docs/highlight_1.png)

Later on, the chat room is shown:

![Spotlighting the user list](https://raw.github.com/mizzao/meteor-tutorials/master/docs/highlight_2.png)

The awesomeness of this tutorial is that it's completely autogenerated and moves with your code. All you have to do is specify the templates for each step and a selector for what should be spotlighted, and the spotlight and modal positions are computed automatically. This means that you won't have to hardcode anything or do much maintenance when your app changes. Best of all, it's animated and looks great!

## Usage

First, specify some templates for your tutorial. Easy as pie:

```html
<template name="tutorial_step1">
    This is step 1 of the tutorial.
</template>

<template name="tutorial_step2">
    This is step 2 of the tutorial.
</template>
```

Next, define the steps of your tutorial in a helper accessible by whatever template is drawing the tutorial.

```js
Template.foo.steps = [
  {
    template: Template.tutorial_step1,
    onLoad: function() { console.log("The tutorial has started!"); }
  },
  {
    template: Template.tutorial_step2,
    spot: ".myElement, .otherElement"
  }
];
```

The steps of the tutorial should be an array of objects, which take the following form:

- `template`: The template that should be displayed in the modal for this step
- `spot`: jQuery selector of elements to highlight (can be a single selector or separated by commas). If multiple elements are selected, the tutorial automatically calculates a box that will fit around all of them.
- `onLoad`: a function that will run whenever the tutorial hits this step. Helpful if you need to make sure your interface is in a certain state before displaying the tutorial contents.

Now, just call the `tutorial` helper with your `steps` from a template whose [offset parent](http://api.jquery.com/offsetParent/) is the same size as the body. This is necessary because the tutorial content is absolutely positioned relative to the window.

```html
<template name="foo">
  {{! My cool user interface}}

  {{#if tutorialEnabled}}
    {{tutorial steps}}
  {{/if}}
<template>
```

Enjoy as your users learn how to use your app much quicker!
