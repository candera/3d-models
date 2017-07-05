(require '[scad-clj.scad :refer :all]
         '[scad-clj.model :refer :all])

(defn degrees [d]
  (-> d (/ 180.0) (* Math/PI)))

(def x-axis [1 0 0])
(def y-axis [0 1 0])
(def z-axis [0 0 1])

(defn u
  "U channel"
  [gap-width gap-height wall-thickness length]
  (let [width (+ (* 2 wall-thickness) gap-width)
        height (+ gap-height wall-thickness)]
    (->> (cube gap-width (+ 1 length) (+ gap-height 1) :center false)
         (translate [wall-thickness -0.5 -1])
         (difference (cube width
                           length
                           height
                           :center false)))))

(defn corner-clip
  [{:keys [wall-thickness gap1 gap2 length height]}]
  (let [c1 (u gap1 height wall-thickness length)
        c2 (u gap2 height wall-thickness length)
        c3 (u gap1 (+ gap2 wall-thickness) wall-thickness length)]
    (union c1
           (->> c2
                (rotate (degrees -90) y-axis)
                (translate [(+ height gap1 (* 3 wall-thickness))
                            0
                            (+ height wall-thickness)]))
           (->> c3
                (translate [0 0 (+ height wall-thickness)])))))

(defn reducer-clip
  [{:keys [gap1 gap2 height1 height2 wall-thickness length]}]
  (let [c1 (u gap1 height1 wall-thickness length)
        c2 (u gap2 height2 wall-thickness length)]
    (union c1
           (->> c2
                (mirror z-axis)
                (translate [0 0 (+ height1 height2 (* 2 wall-thickness))])))))

(->> (corner-clip {:wall-thickness 3 :gap1 5.7 :gap2 5.7 :length 18 :height 15})
     write-scad
     (spit "corner-clip-sm-sm.scad"))

(->> (corner-clip {:wall-thickness 3 :gap1 5.7 :gap2 18 :length 18 :height 15})
     write-scad
     (spit "corner-clip-sm-lg.scad"))

(->> (corner-clip {:wall-thickness 3 :gap1 18 :gap2 18 :length 18 :height 15})
     write-scad
     (spit "corner-clip-lg-lg.scad"))

(->> (reducer-clip {:gap1 5.7
                    :gap2 18
                    :height1 15
                    :height2 15
                    :wall-thickness 3
                    :length 18})
     write-scad
     (spit "reducer-clip.scad"))


