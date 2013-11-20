if (Meteor.isClient) {
  // client code
  Router.configure({
    layoutTemplate: 'hello'
  });

  Router.map(function(){
    this.route('home', {path: '/'});
    this.route('pics');
    this.route('words');
  })

  Session.set('tutorialEnabled', true);

  Template.home.helpers({
    tutorialEnabled: function(){
      return Session.get('tutorialEnabled')
    }
  });

  Template.words.helpers({
    tutorialEnabled: function(){
      return Session.get('tutorialEnabled')
    }
  });

  var homeTutorialSteps = [
    {
      template: Template.tutorial_step1,
      onLoad: function() { console.log("The tutorial has started!"); }
    },
    {
      template: Template.tutorial_step2,
      spot: ".nav"
    }
  ];

  var wordsTutorialSteps = [
    {
      template: Template.tutorial_step3,
      spot: ".words"
    }
  ]

  Template.home.options = {
    steps: homeTutorialSteps,
    onFinish: function(){
      Router.go('words');
    }
  }

  Template.words.options = {
    steps: wordsTutorialSteps,
    onFinish: function(){
      Session.set('tutorialEnabled', false)
    }
  }



}

if (Meteor.isServer) {
  // server code
  Meteor.startup(function () {
    // code to run on server at startup
  });
}
