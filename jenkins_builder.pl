

#!/usr/bin/perl

open(my $fh, '>', '.jenkins.yaml') or die "Could not open file '.jenkins.yaml' $!";
my ($mn_v, $cm_reg_v, $cm_reg_base_v, $cm_reg_shib_v, $cm_reg_shib_base_v, $cm_reg_slapd_base_v);
my $replace = 0;

while (<STDIN>) {

  my $verbose = 1;

  if ( $_ =~ /MAILMAN_VERSION:\s+\"(.+)\"$/ ) {
    $mm_v = $1;
    printf "MAILMAN_VERSION: $mm_v found, using for .jenkins.yaml\n" if $verbose;
  }

  if ( $_ =~ /COMANAGE_REGISTRY_VERSION:\s+\"(.+)\"$/ ) {
    $cm_reg_v = $1;
    printf "COMANAGE_REGISTRY_VERSION: $cm_reg_v found, using for .jenkins.yaml\n" if $verbose;
  }

  if ( $_ =~ /COMANAGE_REGISTRY_BASE_IMAGE_VERSION:\s+\"(.+)\"$/ ) {
    $cm_reg_base_v = $1;
    printf "COMANAGE_REGISTRY_VERSION: $cm_reg_base_v found, using for .jenkins.yaml\n" if $verbose;
  }

  if ( $_ =~ /COMANAGE_REGISTRY_SHIBBOLETH_SP_VERSION:\s+\"(.+)\"$/ ) {
    $cm_reg_shib_v = $1;
    printf "COMANAGE_REGISTRY_SHIBBOLETH_SP_VERSION: $cm_reg_shib_v found, using for .jenkins.yaml\n" if $verbose;
  }

  if ( $_ =~ /COMANAGE_REGISTRY_SHIBBOLETH_SP_BASE_IMAGE_VERSION:\s+\"(.+)\"$/ ) {
    $cm_reg_shib_base_v = $1;
    printf "COMANAGE_REGISTRY_VERSION: $cm_reg_shib_base_v found, using for .jenkins.yaml\n" if $verbose;
  }

  if ( $_ =~ /COMANAGE_REGISTRY_SLAPD_BASE_IMAGE_VERSION:\s+\"(.+)\"$/ ) {
    $cm_reg_slapd_base_v = $1;
    printf "COMANAGE_REGISTRY_SLAPD_BASE_IMAGE_VERSION: $cm_reg_slapd_base_v found, using for .jenkins.yaml\n" if $verbose;
  }

  if ( $_ =~ /extra_jobs/ ) { 
    # From this on in the file: Search and replace all version entries in .jenkins.yaml
    $replace = 1;
  }

  if ( $replace eq 1 ) {
    $_ =~ s/\${MAILMAN_VERSION}/$mm_v/g;
    $_ =~ s/\${COMANAGE_REGISTRY_VERSION}/$cm_reg_v/g;
    $_ =~ s/\${COMANAGE_REGISTRY_BASE_IMAGE_VERSION}/$cm_reg_base_v/g;
    $_ =~ s/\${COMANAGE_REGISTRY_SHIBBOLETH_SP_VERSION}/$cm_reg_shib_v/g;
    $_ =~ s/\${COMANAGE_REGISTRY_SHIBBOLETH_SP_BASE_IMAGE_VERSION}/$cm_reg_shib_base_v/g;
    $_ =~ s/\${COMANAGE_REGISTRY_SLAPD_BASE_IMAGE_VERSION}/$cm_reg_slapd_base_v/g;
  }

printf $fh "$_";


}

close($fh);

__END__

environment_variables:
  MAILMAN_VERSION: "0.1.7"
  COMANAGE_REGISTRY_VERSION: "3.2.3"
  COMANAGE_REGISTRY_BASE_IMAGE_VERSION: "1"
  COMANAGE_REGISTRY_SHIBBOLETH_SP_VERSION: "3.0.4"
  COMANAGE_REGISTRY_SHIBBOLETH_SP_BASE_IMAGE_VERSION: "1"
  COMANAGE_REGISTRY_SLAPD_BASE_IMAGE_VERSION: "2"

      - "${COMANAGE_REGISTRY_VERSION}-${COMANAGE_REGISTRY_BASE_IMAGE_VERSION}"
      - "${COMANAGE_REGISTRY_VERSION}-${COMANAGE_REGISTRY_BASE_IMAGE_VERSION}"


