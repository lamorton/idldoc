;+
; The getVariable method is required for objects passed as an input to a
; template.
;
; @returns value or -1L if variable name not found
; @param name {in}{required}{type=string}
;        name of variable (case insensitive)
; @keyword found {out}{optional}{type=boolean}
;          pass a named variable to get whether the variable was found
;-
function doctreeargument::getVariable, name, found=found
  compile_opt strictarr
  on_error, 2
  
  ; make sure name is present, a string, and only 1 element
  if (n_elements(name) ne 1 || size(name, /type) ne 7) then begin
    message, 'name parameter invalid'
  endif
  
  ; return value if name is ok
  found = 1B
  case name of
    'name' : return, self.name
    'iskeyword' : return, self.isKeyword
    'isoptional' : return, self.isOptional
    'isrequired' : return, self.isRequired
    'isinput' : return, self.isInput
    'isoutput' : return, self.isOutput
    'type' : return, self.type
    'isboolean' : return, strlowcase(self.type) eq 'boolean'
    'defaultvalue' : return, self.defaultValue
    'ishidden' : return, self.isHidden
    'isprivate' : return, self.isPrivate
    'prefix' : begin
      self.routine->getProperty, is_function=isFunction
      return, (isFunction && self.isFirst) ? '(' : ', '
    end
    'suffix' : begin
      self.routine->getProperty, is_function=isFunction
      return, isFunction ? ')' : ''
    end
    'comments' : begin
      comments = self.comments->get(/all, count=count)
      return, count eq 0 ? '' : comments
    end
    else : begin
      found = 0B
      return, -1L
    end
  endcase
end


;+
; Set properties of the argument.
; 
; @keyword routine {out}{optional}{type=object}
;          DOCtreeRoutine object that contains this argument
; @keyword name {out}{optional}{type=string}
;          name of the routine
; @keyword is_first {out}{optional}{type=boolean}
;          set to indicate that this argument is the first of its parent routine
; @keyword is_keyword {out}{optional}{type=boolean}
;          set to indicate that this argument is a keyword
; @keyword is_optional {out}{optional}{type=boolean}
;          set to indicate that this argument is optional
; @keyword is_required {out}{optional}{type=boolean}
;          set to indicate that this argument is required
; @keyword is_input {out}{optional}{type=boolean}
;          set to indicate that this argument is an input
; @keyword is_output {out}{optional}{type=boolean}
;          set to indicate that this arugment is an output
; @keyword type {out}{optional}{type=string}
;          string indicating the IDL variable type of the argument
; @keyword default_value {out}{optional}{type=string}
;          string indicating the default value if this argument is not present
; @keyword is_hidden {out}{optional}{type=boolean}
;          set to indicate that this argument is hidden (hidden from users and
;          developers)
; @keyword is_private {out}{optional}{type=boolean}
;          set to indicate that this argument is private (hidden from users)
; @keyword comments {out}{optional}{type=object}
;          MGcoArrayList of comments for this argument
;-
pro doctreeargument::getProperty, routine=routine, name=name, $
    is_first=isFirst, is_keyword=isKeyword, is_optional=isOptional, $
    is_required=isRequired, is_input=isInput, is_output=isOutput, $
    type=type, default_value=defaultValue, is_hidden=isHidden, $
    is_private=isPrivate, comments=comments  
  compile_opt strictarr
  
  if (arg_present(routine)) then routine = self.routine
  if (arg_present(name)) then name = self.name
  if (arg_present(isFirst)) then isFirst = self.isFirst  
  if (arg_present(isKeyword)) then isKeyword = self.isKeyword  
  if (arg_present(isOptional)) then isOptional = self.isOptional    
  if (arg_present(isRequired)) then isRequired = self.isRequired      
  if (arg_present(isInput)) then isInput = self.isInput    
  if (arg_present(isOutput)) then isOutput = self.isOutput      
  if (arg_present(type)) then type = self.type      
  if (arg_present(defaultValue)) then defaultValue = self.defaultValue      
  if (arg_present(isHidden)) then isHidden = self.isHidden      
  if (arg_present(isPrivate)) then isPrivate = self.isPrivate      
  if (arg_present(comments)) then comments = self.comments      
end


;+
; Set properties of the argument.
; 
; @keyword is_first {in}{optional}{type=boolean}
;          set to indicate that this argument is the first of its parent routine
; @keyword is_keyword {in}{optional}{type=boolean}
;          set to indicate that this argument is a keyword
; @keyword is_optional {in}{optional}{type=boolean}
;          set to indicate that this argument is optional
; @keyword is_required {in}{optional}{type=boolean}
;          set to indicate that this argument is required
; @keyword is_input {in}{optional}{type=boolean}
;          set to indicate that this argument is an input
; @keyword is_output {in}{optional}{type=boolean}
;          set to indicate that this arugment is an output
; @keyword type {in}{optional}{type=string}
;          string indicating the IDL variable type of the argument
; @keyword default_value {in}{optional}{type=string}
;          string indicating the default value if this argument is not present
; @keyword is_hidden {in}{optional}{type=boolean}
;          set to indicate that this argument is hidden (hidden from users and
;          developers)
; @keyword is_private {in}{optional}{type=boolean}
;          set to indicate that this argument is private (hidden from users)
; @keyword comments {in}{optional}{type=string/strarr}
;          string or string array of comments for this argument
;-
pro doctreeargument::setProperty, is_first=isFirst, is_keyword=isKeyword, $
    is_optional=isOptional, is_required=isRequired, is_input=isInput, $
    is_output=isOutput, type=type, default_value=defaultValue, $
    is_hidden=isHidden, is_private=isPrivate, comments=comments
  compile_opt strictarr
  
  if (n_elements(isFirst) gt 0) then self.isFirst = isFirst
  if (n_elements(isKeyword) gt 0) then self.isKeyword = isKeyword
  if (n_elements(isOptional) gt 0) then self.isOptional = isOptional
  if (n_elements(isRequired) gt 0) then self.isRequired = isRequired
  if (n_elements(isInput) gt 0) then self.isInput = isInput
  if (n_elements(isOutput) gt 0) then self.isOutput = isOutput
  if (n_elements(type) gt 0) then self.type = type
  if (n_elements(defaultValue) gt 0) then self.defaultValue = defaultValue
  if (n_elements(isHidden) gt 0) then self.isHidden = isHidden
  if (n_elements(isPrivate) gt 0) then self.isPrivate = isPrivate
  if (n_elements(comments) gt 0) then begin
    self.comments->add, comments
  endif
end


;+
; Free resources lower in the hierarchy.
;-
pro doctreeargument::cleanup
  compile_opt strictarr
  
  obj_destroy, self.comments
end


;+
; Create an argument: positional parameter or keyword.
; 
; @returns 1 for success, 0 for failure
; @param routine {in}{required}{type=object}
;        DOCtreeRoutine object
;-
function doctreeargument::init, routine, name
  compile_opt strictarr
  
  self.routine = routine
  self.name = name
  
  ; list of strings
  self.comments = obj_new('MGcoArrayList', type=7)
  
  return, 1
end


;+
; Define the instance variables.
;
; @field routine DOCtreeRoutine object that contains this argument
; @field name name of the argument
; @field isFirst indicates that this argument is the first of its parent routine
; @field isKeyword indicates that this argument is a keyword
; @field isOptional indicates that this argument is optional
; @field isRequired indicates that this argument is required
; @field isInput indicates that this argument is an input
; @field isOutput indicates that this arugment is an output
; @field type string indicating the IDL variable type of the argument
; @field defaultValue string indicating the default value if this argument is 
;        not present
; @field isHidden indicates that this argument is hidden (hidden from users and
;        developers)
; @field isPrivate indicates that this argument is private (hidden from users)
; @field comments MGcoArrayList of comments for this argument
;-
pro doctreeargument__define
  compile_opt strictarr
  
  define = { DOCtreeArgument, $
             routine: obj_new(), $
             name: '', $
             isFirst: 0B, $
             isKeyword: 0B, $
             isOptional: 0B, $
             isRequired: 0B, $
             isInput: 0B, $
             isOutput: 0B, $
             type: '', $
             defaultValue: '', $
             isHidden: 0B, $
             isPrivate: 0B, $
             comments: obj_new() $
           }
end