package Koha::Plugin::Fi::KohaSuomi::SetDefaults;

## It's good practice to use Modern::Perl
use Modern::Perl;

## Required for all plugins
use base qw(Koha::Plugins::Base);
## We will also need to include any Koha libraries we want to access
use C4::Context;
use utf8;
use File::Slurp;

## Here we set our plugin version
our $VERSION = "1.0.0";

## Here is our metadata, some keys are required, some are optional
our $metadata = {
    name            => "IntranetUserJS: Set defaults for Koha fields and checkboxes",
    author          => 'Lari Strand',
    date_authored   => '2024-09-04',
    date_updated    => '2024-09-04',
    minimum_version => '23.11',
    maximum_version => '',
    version         => $VERSION,
    description     => "Asettaa Kohaan oletusarvoja eri kentille ja valintaruuduille. Määriteltävä.",
};

## This is the minimum code required for a plugin's 'new' method
## More can be added, but none should be removed
sub new {
    my ( $class, $args ) = @_;

    ## We need to add our metadata here so our base class can access it
    $args->{'metadata'} = $metadata;
    $args->{'metadata'}->{'class'} = $class;

    ## Here, we call the 'new' method for our base class
    ## This runs some additional magic and checking
    ## and returns our actual 
    my $self = $class->SUPER::new($args);

    return $self;
}

## If your plugin needs to add some javascript in the staff intranet, you'll want
## to return that javascript here. Don't forget to wrap your javascript in
## <script> tags. By not adding them automatically for you, you'll have a
## chance to include other javascript files if necessary.
sub intranet_js {
    my ( $self, $args ) = @_;

    my $dir=C4::Context->config('pluginsdir');
    my $plugin_fulldir = $dir . "/Koha/Plugin/Fi/KohaSuomi/SetDefaults/";
    my $js = read_file($plugin_fulldir .'script.js');
    
    my $param_a = $self->retrieve_data('config_param_a') || 0;
    my $param_b = $self->retrieve_data('config_param_b') || 0;
    my $param_c = $self->retrieve_data('config_param_c') || 0;
    my $param_d = $self->retrieve_data('config_param_d') || 0;
    
    # Add REPLACE_BY_CONFIG_PARAM_A to the js script to replace it with the configuration parameter
    $js = $js =~ s/REPLACE_BY_CONFIG_PARAM_A/$param_a/r;
    $js = $js =~ s/REPLACE_BY_CONFIG_PARAM_B/$param_b/r;
    $js = $js =~ s/REPLACE_BY_CONFIG_PARAM_C/$param_c/r;
    $js = $js =~ s/REPLACE_BY_CONFIG_PARAM_D/$param_d/r;
    
    utf8::decode($js);
    return "<script>$js</script>";
}

## The existance of a 'tool' subroutine means the plugin is capable
## of running a tool. The difference between a tool and a report is
## primarily semantic, but in general any plugin that modifies the
## Koha database should be considered a tool
sub tool {
    my ( $self, $args ) = @_;
    
    my $cgi = $self->{'cgi'};
    my $template = $self->get_template({ file => 'viewjs.tt' });
    
    my $plugin_fulldir = $self->mbf_path();
    my $js = read_file($plugin_fulldir .'script.js');
    
    # my $param_a = $self->retrieve_data('config_param_a');
    
    ## Add REPLACE_BY_CONFIG_PARAM_A to the js script to replace it with the configuration parameter
    # $js = $js =~ s/REPLACE_BY_CONFIG_PARAM_A/$param_a/r;
    
    utf8::decode($js);
    $template->param( 'jscontent' => $js );

    $self->output_html( $template->output() );
}

# If your tool is complicated enough to needs it's own setting/configuration
# you will want to add a 'configure' method to your plugin like so.
# Here I am throwing all the logic into the 'configure' method, but it could
# be split up like the 'report' method is.
sub configure {
    my ( $self, $args ) = @_;
    my $cgi = $self->{'cgi'};

    unless ( $cgi->param('save') ) {
        my $template = $self->get_template({ file => 'configure.tt' });

        ## Grab the values we already have for our settings, if any exist
        $template->param(
            config_param_a => $self->retrieve_data('config_param_a'),
            config_param_b => $self->retrieve_data('config_param_b'),
            config_param_c => $self->retrieve_data('config_param_c'),
            config_param_d => $self->retrieve_data('config_param_d'),
            last_upgraded   => $self->retrieve_data('last_upgraded'),
        );

        $self->output_html( $template->output() );
    }
    else {
        $self->store_data(
            {
                config_param_a => $cgi->param('config_param_a'),
                config_param_b => $cgi->param('config_param_b'),
                config_param_c => $cgi->param('config_param_c'),
                config_param_d => $cgi->param('config_param_d'),
                last_configured_by => C4::Context->userenv->{'number'},
            }
        );
        $self->go_home();
    }
}

## This is the 'install' method. Any database tables or other setup that should
## be done when the plugin if first installed should be executed in this method.
## The installation method should always return true if the installation succeeded
## or false if it failed.
sub install() {
    my ( $self, $args ) = @_;

    return 1;
}

## This is the 'upgrade' method. It will be triggered when a newer version of a
## plugin is installed over an existing older version of a plugin
sub upgrade {
    my ( $self, $args ) = @_;

    return 1;
}

## This method will be run just before the plugin files are deleted
## when a plugin is uninstalled. It is good practice to clean up
## after ourselves!
sub uninstall() {
    my ( $self, $args ) = @_;

    return 1;
}

1;

