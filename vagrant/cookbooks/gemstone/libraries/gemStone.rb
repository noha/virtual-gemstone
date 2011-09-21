class Chef::Recipe::GemStone
   @@topazTemplate = "source /opt/gemstone/product/seaside/defSeaside
echo \"set gemstone ##STONE_NAME##
set username DataCurator
set password swordfish
iferr 1 exit 1
login
run
##EXPRESSION##
%
logout
exit 0\" | topaz -l"

   def self.prepareTopazTemplate(stoneName, expression)
      template = @@topazTemplate.clone
      template['##STONE_NAME##'] = stoneName
      template['##EXPRESSION##'] = expression
      template
   end

   def self.isTrue(stoneName, expression)
      topazExpression = "(" << expression << ") ifFalse: [ Error signal: 'false' ]"
      prepareTopazTemplate(stoneName, topazExpression)
   end

   def self.isNotNil(stoneName, expression)
      topazExpression = "(" << expression << ") isNil ifTrue: [ Error signal: 'false' ]"
      prepareTopazTemplate(stoneName, topazExpression)
   end

   def self.isDefinedClass(stoneName, expression)
      isNotNil(stoneName, "Smalltalk at: #" << expression);
   end
end
