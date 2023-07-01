let $rootTagname := 'root'
let $elementTagname := 'element'
let $elementContent := 'Some text here'

return
  element {$rootTagname}
          {
            element{$elementTagname}
                   {$elementContent}
          }
