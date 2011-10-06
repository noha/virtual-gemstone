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
end
