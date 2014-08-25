Package.describe({
  summary: "Create super cool animated tutorials for your Meteor app",
  version: "0.6.3",
  git: "https://github.com/mizzao/meteor-tutorials.git"
});

Package.onUse(function (api) {
  api.versionsFrom("METEOR-CORE@0.9.0-atm");

  api.use(['jquery', 'stylus', 'coffeescript'], 'client');
  api.use(['ui', 'templating'], 'client');

  api.use("mrt:bootstrap-3@3.2.0-1", 'client');

  api.add_files('templates.html', 'client');
  api.add_files('tutorial.styl', 'client');

  api.add_files('eventEmitter.coffee', 'client');
  api.add_files('drags.js', 'client');

  api.add_files('tutorial.coffee', 'client');
  api.add_files('helpers.coffee', 'client');

  api.export('EventEmitter', 'client');
});
