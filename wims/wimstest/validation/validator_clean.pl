#!/usr/bin/perl -w


use strict "vars";
use strict "subs";
use locale;
use warnings;
#$/ = undef;

my $warning1='is the first character of a delimiter but occurred as data';
my $warning2="info: line \$";
my $warning21=": character \"&\" is the first character of a delimiter but occurred as data";
my $warning3="Stray start tag div.";
#my $warning4="Self-closing tag syntax";
my $DIR=".";
my $option='';
while ($_ = shift(@ARGV))
{
  last if (/^$/);
  if (/^--option=(.*)$/)  { $option = $1}
  elsif  (/^--dir=(.*)$/)   {$DIR = $1 }
}
my @Files = GetFilesList ($DIR);
foreach my $File  (@Files) {
	treate($File);
	if($option==1){ treate2($File)};
}

sub treate { my ($file)=@_;
  my $text='';
  open(IN,$file);
  while (<IN>) {
    next if (/$warning1/);
    next if (/$warning3/);
    next if (/$warning2\d+$warning21/);
    next if (/no attribute "autocompletion"/);
    next if (/no attribute "autocomplete"/);
    next if (/validating: test.html/);
    #next if (/$warning4/);
    $text .= $_;
  }
  close IN;
  out($file, $text);
}

sub treate2 { my ($file)=@_;
  my $text='';
  open(IN,$file);
  while (<IN>) {
    next if (/start tag was here/);
    ##next if (/value of attribute "type" cannot be "search"/);
    ##next if (/there is no attribute "results"/);
    ## next if (/there is no attribute "placeholder"/);
    next if (/there is no attribute "name"/);
    ##next if (/there is no attribute "type"/);
    next if (/Attribute "results" not allowed on element "input" at this point/);
    next if (/Attribute “results” not allowed on element “input” at this point/);
    next if (/Attribute results not allowed on element input at this point/);
    next if (/document type does not allow element "style" here/);
    next if (/document type does not allow element "div" here\s*END/); ## last in the result come from the debug
    next if (/document type does not allow element "link" here/);
    next if (/Legacy encoding /);
    next if (/The only allowed value for the /);
    next if (/Cannot recover after last error. Any further errors will be ignored./);
    next if (/Stray start tag “div”./);
    next if (/Stray start tag "div"./);
    next if (/attribute is unnecessary for JavaScript resources./);
    next if (/attribute for the “style” element is not needed and should be omitted./);
    $text .= $_;
  };
  close IN;
  $text =~ s/line \d+://g;
  $text =~ s/END//g;
  $text =~ s/\n{2,}/\n/g;
  my $text1="";
  my @test=split("\n",$text);
  for (my $i=0; $i < $#test; $i++) {
    chomp $test[$i]; chomp $test[$i+1];
    if( !($test[$i] =~ /BEGIN/ && $test[$i+1] =~ /BEGIN/)) {
      $text1 .= "\n" . $test[$i];
    }
  }
  $text=$text1;
  $text=~ s/BEGIN//g;
  #if ($text =~ /error|info/) {  } else { $text='' };
  out($file, $text);
}
sub out { my ($bloc, $text) = @_;
  open  (OUT, ">$bloc") || warn "peut pas créer $bloc";
  print OUT $text; close OUT;
}

sub GetFilesList
{
  my $Path = $_[0];
  my $FileFound;
  my @FilesList=();

  # Lecture de la liste des fichiers
  opendir (my $FhRep, $Path)
    or die "Impossible d'ouvrir le repertoire $Path\n";
  my @Contenu = grep { !/^\.\.?$/ } readdir($FhRep);
  closedir ($FhRep);

  foreach my $FileFound (@Contenu) {
    # Traitement des fichiers
    if ( -f "$Path/$FileFound") {
      push ( @FilesList, "$Path/$FileFound" );
    }
    # Traitement des repertoires
    elsif ( -d "$Path/$FileFound") {
      # Boucle pour lancer la recherche en mode recursif
      push (@FilesList, GetFilesList("$Path/$FileFound") );
    }
  }
  return @FilesList;
}
