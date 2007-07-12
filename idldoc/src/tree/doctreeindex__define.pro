; need:
;   - a way to partition given a number of items per page
;   - a way to iterate through the results

;+
; Returns an array of first letters of the names of the items in the index.
;
; @returns strarr
; @keyword count {out}{optional}{type=long}
;          number of first letters for items in the index
;-
function doctreeindex::getFirstLetters, count=count
  compile_opt strictarr
  
  ind = where(self.letters, count)
  if (count gt 0) then begin
    return, string(reform(byte(ind), 1, count))
  endif else begin
    return, -1L
  endelse
end


;+
; Add the item to the index.
;- 
pro doctreeindex::add, item
  compile_opt strictarr

  item->getProperty, name=name
  self.items->put, { name: name, item: item }
  ++self.letters[byte(strupcase(strmid(name, 0, 1)))]
end


;+
; Free resources of index.
;-
pro doctreeindex::cleanup
  compile_opt strictarr
  
  obj_destroy, self.items
end


;+
; Create the index.
; 
; @returns 1 for success, 0 for failure
;-
function doctreeindex::init
  compile_opt strictarr

  ; strings -> objects
  self.items = obj_new('MGcoArraylist', example={ name:'', item: obj_new() })
  
  return, 1
end


;+
; Define instance variables.
;
; @field items hash table of strings -> objects (index names to DOCtree* 
;        objects)
; @field letters histogram of letter usage
;-
pro doctreeindex__define
  compile_opt strictarr

  define = { DOCtreeIndex, $
             items: obj_new(), $
             letters: lonarr(256) $
           }
end