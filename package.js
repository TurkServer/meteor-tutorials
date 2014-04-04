Package.describe({
    summary: "Create super cool animated tutorials for your Meteor app"
});

Package.on_use(function (api) {
    api.use(['jquery', 'stylus', 'coffeescript'], 'client');
    api.use(['ui', 'templating'], 'client');

    // TODO: Replace me with Bootstrap 3
    api.use('bootstrap', 'client');

    api.add_files('templates.html', 'client');
    api.add_files('tutorial.styl', 'client');

    api.add_files('drags.js', 'client');
    api.add_files('tutorial.coffee', 'client');
    api.add_files('helpers.coffee', 'client');
});

