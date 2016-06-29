(cl:in-package #:climacs-flexichain-output-history)

(defclass flexichain-output-history
    (clim:output-record clim:stream-output-history-mixin)
  ((%parent :initarg :parent :reader clim:output-record-parent)
   (%lines :initform (make-instance 'flexichain:flexichain) :reader lines)
   (%width :initform 0 :accessor width)
   (%height :initform 0 :accessor height)))

(defmethod clim:replay-output-record
    ((record flexichain-output-history) stream &optional region x-offset y-offset)
  (declare (ignore x-offset y-offset))
  (multiple-value-bind (left top right bottom)
      (clim:bounding-rectangle* (clim:pane-viewport-region stream))
    (clim:medium-clear-area (clim:sheet-medium stream)
			    left top right bottom)
    (loop with lines = (lines record)
	  with length = (flexichain:nb-elements lines)
	  for i from 0 below length
	  for line = (flexichain:element* lines i) 
	  for height = (clim:bounding-rectangle-height line)
	  for y = 0 then (+ y height 5)
	  while (< y bottom)
	  do (setf (clim:output-record-position line) (values 0 y))
	     (clim:replay-output-record line stream region))))

(defmethod clim:bounding-rectangle* ((history flexichain-output-history))
  (values 0 0 (width history) (height history)))
