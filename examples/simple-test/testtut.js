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
  var emitter = new EventEmitter();

  Template.home.tutorialEnabled = function() {
      return Session.get('tutorialEnabled')
  };

  Template.words.events = {
    "click .words": function() {
      emitter.emit("wordsClick");
    }
  };

  Template.words.tutorialEnabled = function() {
      return Session.get('tutorialEnabled')
  };

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
      spot: ".words",
      require: {
        event: "wordsClick"
      }
    },
    {
      template: Template.tutorial_step4,
      spot: "body"
    }
  ];

  Template.home.options = {
    steps: homeTutorialSteps,
    onFinish: function(){
      Router.go('words');
    }
  };

  Template.words.options = {
    steps: wordsTutorialSteps,
    emitter: emitter,
    onFinish: function() {
      console.log("Finish clicked!");
      Meteor.setTimeout( function () {
        // Test debouncing
        Session.set('tutorialEnabled', false);
      }, 1000);
    }
  };

}

if (Meteor.isServer) {
  // server code
  Meteor.startup(function () {
    // code to run on server at startup
  });
}
