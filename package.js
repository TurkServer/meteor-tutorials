Package.describe({
  summary: "Create super cool animated tutorials for your Meteor app",
  version: "0.6.4",
  git: "https://github.com/mizzao/meteor-tutorials.git"
});

Package.onUse(function (api) {
  api.versionsFrom("METEOR@0.9.4");

  api.use(['jquery', 'stylus', 'coffeescript'], 'client');
  api.use(['ui', 'templating'], 'client');

  api.use("mizzao:bootstrap-3@3.2.0_1", 'client');

  api.addFiles('templates.html', 'client');
  api.addFiles('tutorial.styl', 'client');

  api.addFiles('eventEmitter.coffee', 'client');
  api.addFiles('drags.js', 'client');

  api.addFiles('tutorial.coffee', 'client');
  api.addFiles('helpers.coffee', 'client');

  api.export('EventEmitter', 'client');
});
