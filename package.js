Package.describe({
    summary: "Create super cool animated tutorials for your Meteor app"
});

Package.on_use(function (api) {
    api.use(['bootstrap', 'jquery', 'handlebars', 'templating', 'stylus', 'coffeescript'], 'client');

    api.add_files('templates.html', 'client');
    api.add_files('tutorial.styl', 'client');

    api.add_files('tutorial.coffee', 'client');
    api.add_files('helpers.coffee', 'client');
});

