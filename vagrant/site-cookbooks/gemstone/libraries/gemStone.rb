class Chef::Recipe::GemStone
   @@topazTemplate = "source /etc/gemstone/stones.d/##STONE_NAME##
source $STONE_DIR/env
echo \"set gemstone ##STONE_NAME##
set username DataCurator
set password swordfish
iferr 1 exit 1
login
run
##EXPRESSION##
%
commit
logout
exit 0\" | topaz -l"

   def self.prepareTopazTemplate(stoneName, expression)
      template = @@topazTemplate.clone
      template['##STONE_NAME##'] = stoneName
      template['##STONE_NAME##'] = stoneName
      template['##EXPRESSION##'] = expression
      template
   end

   def self.isTrue(stoneName, expression)
      doIt(stoneName, "(" << expression << ") ifFalse: [ Error signal: 'false' ]")
   end

   def self.isNotNil(stoneName, expression)
      doIt("stone-default", "(" << expression << ") isNil ifTrue: [ Error signal: 'false' ]")
   end

   def self.isDefinedClass(stoneName, expression)
      isNotNil(stoneName, "Smalltalk at: #" << expression);
   end

   def self.doIt(stoneName, expression)
      prepareTopazTemplate(stoneName, expression)
   end

   def self.updateGLASS(stoneName)
      doIt(stoneName, "| versionString |
versionString := '1.0-beta.8.7.3'.
MCPlatformSupport
  autoCommit: true;
  autoMigrate: true.
ConfigurationOfMetacello project currentVersion versionNumber < '1.0-beta.31.1' asMetacelloVersionNumber
    ifTrue: [
        (Gofer new)
            gemsource: 'metacello';
            version: 'Gofer-Core.gemstone-dkh.135';
            version: 'Metacello-Base-DaleHenrichs.19';
            version: 'Metacello-Core-dkh.468';
            version: 'Metacello-MC-dkh.531';
            version: 'Metacello-Platform.gemstone-dkh.23';
            load].
MCPlatformSupport commitOnAlmostOutOfMemoryDuring: [[[
  ConfigurationOfGLASS project updateProject.
  (ConfigurationOfGLASS project version: versionString) load: #( 'Core' 'Monticello' ).
  (ConfigurationOfGLASS project version: versionString) load.
 ]
    on: (Smalltalk at: #MetacelloSkipDirtyPackageLoad)
    do: [:ex | ex resume: false ]]
        on: Warning
        do: [:ex |
            Transcript cr; show: ex description.
            ex resume ]].
      ")
   end
end