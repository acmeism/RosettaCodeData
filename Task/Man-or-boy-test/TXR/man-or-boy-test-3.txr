(defstruct (cbn-thunk get set) nil get set)

(defmacro make-cbn-val (place)
  (with-gensyms (nv tmp)
    (cond
      ((constantp place)
        ^(let ((,tmp ,place))
           (new cbn-thunk
             get (lambda () ,tmp)
             set (lambda (,nv) (set ,tmp ,nv)))))
      ((bindable place)
        ^(new cbn-thunk
           get (lambda () ,place)
           set (lambda (,nv) (set ,place ,nv))))
      (t
        ^(new cbn-thunk
           get (lambda () ,place)
           set (lambda (ign) (error "cannot set ~s" ',place)))))))

(defun cbn-val (cbs)
  (call cbs.get))

(defun set-cbn-val (cbs nv)
  (call cbs.set nv))

(defplace (cbn-val thunk) body
  (getter setter
    (with-gensyms (thunk-tmp)
      ^(rlet ((,thunk-tmp ,thunk))
         (macrolet ((,getter () ^(cbn-val ,',thunk-tmp))
                    (,setter (val) ^(set-cbn-val ,',thunk-tmp ,val)))
       ,body)))))

(defun make-cbn-fun (sym args . body)
  (let ((gens (mapcar (ret (gensym)) args)))
    ^(,sym ,gens
       (symacrolet ,[mapcar (ret ^(,@1 (cbn-val ,@2))) args gens]
         ,*body))))

(defmacro cbn (fun . args)
  ^(call (fun ,fun) ,*[mapcar (ret ^(make-cbn-val ,@1)) args]))

(defmacro defun-cbn (name (. args) . body)
  (with-gensyms (hidden-fun)
    ^(progn
       (defun ,hidden-fun ())
       (defmacro ,name (. args) ^(cbn ,',hidden-fun ,*args))
       (set (symbol-function ',hidden-fun)
            ,(make-cbn-fun 'lambda args
                           ^(block ,name (let ((,name)) ,*body ,name)))))))

(defmacro labels-cbn ((name (. args) . lbody) . body)
  (with-gensyms (hidden-fun)
    ^(macrolet ((,name (. args) ^(cbn ,',hidden-fun ,*args)))
       (labels (,(make-cbn-fun hidden-fun args
                               ^(block ,name (let ((,name)) ,*lbody ,name))))
         ,*body))))

(defun-cbn A (k x1 x2 x3 x4 x5)
  (let ((k k))
    (labels-cbn (B ()
                  (dec k)
                  (set B (set A (A k (B) x1 x2 x3 x4))))
      (if (<= k 0)
        (set A (+ x4 x5))
        (B))))) ;; value of (B) correctly discarded here!

(prinl (A 10 1 -1 -1 1 0))
