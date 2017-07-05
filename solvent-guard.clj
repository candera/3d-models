(require '[scad-clj.scad :refer :all]
         '[scad-clj.model :refer :all])


(defn degrees [d]
  (-> d (/ 180.0) (* Math/PI)))

(def x-axis [1 0 0])
(def y-axis [0 1 0])
(def z-axis [0 0 1])

(defn handles
  [{:keys [well-interior-wall-thickness
           well-width
           height-above
           handle-width
           cells-x
           cells-y]}]
  (let [cell-length (+ well-interior-wall-thickness well-width)
        length (* cell-length cells-x)
        handle (cube length
               handle-width
               height-above)]
    (union (->> handle
                (translate [(* cell-length (dec cells-x) 0.5)
                            (- (/ cell-length -2) (/ handle-width 2))
                            (/ height-above 2)])
                (color [0 0 1 1]))
           (->> handle
                (translate [(* cell-length (dec cells-x) 0.5)
                            (- (* cells-y cell-length) well-interior-wall-thickness)
                            (/ height-above 2)])
                (color [0 1 0 1])))))

(defn top
  [{:keys [cells-x cells-y
           well-interior-wall-thickness
           well-exterior-wall-thickness
           well-width
           height-above
           height-below
           guard-wall-thickness
           hole-size
           hole-descent]}]
  (->> (cube (+ well-width well-interior-wall-thickness)
             (+ well-width well-interior-wall-thickness)
             height-above)
       (translate [0 0 (/ height-above 2.0)])))

(defn insert
  [{:keys [height-below well-width] :as params}]
  (->> (cube well-width well-width height-below)
       (translate [0 0 (/ height-below -2.0)])))

(defn taper
  [{:keys [hole-descent well-width height-below hole-radius]}]
  (let [d1 (/ well-width 2.0)
        z1 (- height-below)
        c0 [d1 d1 z1]
        c1 [d1 (- d1) z1]
        c2 [(- d1) (- d1) z1]
        c3 [(- d1) d1 z1]
        c4 [0 0 (- 0 height-below hole-descent)]]
    (difference (polyhedron [c0 c1 c2 c3 c4]
                       [[1 0 4]
                        [2 1 4]
                        [3 2 4]
                        [0 3 4]
                        [0 1 2 3]]
                       :convexity 2)
           (->> (cube well-width well-width hole-descent)
                (translate [0 0 (/ hole-descent -2.0)])
                (translate [0 0 (- height-below)])
                (translate [0 0 (- hole-descent)])
                (translate [0 0 (* hole-descent
                                   (/ hole-radius (/ well-width 2.0)))])
                (color [1 0 0 1])))))

(defn hole
  [{:keys [hole-descent height-below height-above hole-radius]}]
  (let [h (+ hole-descent height-below height-above)]
    (->> (with-fn 24
           (cylinder hole-radius (+ h 4.0)))
         (translate [0 0 (- height-above (/ h 2.0) 1.0)]))))

(defn well
  [params]
  (-> (union (top params)
             (insert params)
             (taper params))
      (difference (hole params))))


(defn guard
  [{:keys [cells-x cells-y
           well-interior-wall-thickness
           well-exterior-wall-thickness
           well-width
           height-above
           height-below
           guard-wall-thickness
           hole-radius
           hole-descent]
    :as params}]
  (->> (apply union
              (handles params)
              (for [x (range cells-x)
                    y (range cells-y)]
                (let [cell-width (+ well-width well-interior-wall-thickness)]
                  (->> (well params)
                       (translate [(* x cell-width)
                                   (* y cell-width)
                                   0])))))
       (rotate (degrees 180) x-axis)))

(let [padding 0.1]
 (->> (guard
       {:cells-x 12
        :cells-y 8
        :well-interior-wall-thickness (+ padding 0.85)
        :well-width (- 8.13 padding)
        :height-above 4
        :height-below 3
        :handle-width 7
        :hole-descent 3
        :hole-radius (/ 6.4 2)})
      write-scad
      (spit "solvent-guard.scad")))


