;;; ==========================================================================
;;;  名稱: FASTCUT.lsp (雷切大面積網格邊界裁切工具 - 絕對不影響 Snap 鎖點版)
;;;  適用: AutoCAD / progeCAD (支援數千至數萬個 1mm/2mm 格子批次處理)
;;;  快捷鍵: FC 或 FTC
;;;  完整指令: FASTCUT
;;; ==========================================================================

(vl-load-com)

(defun c:FASTCUT (/ *error* oldEcho oldDel doc ms entOuter ssBoxes
                    minPt maxPt bbMin bbMax p1 p2 p3 p4 regOuter regMask regInvert
                    ssBoxesReg total entScan entBefore ssRegFinal ssLines)

  ;; 安全錯誤中斷處理 (絕不更改使用者 OSMODE)
  (defun *error* (msg)
    (if oldEcho (setvar "CMDECHO" oldEcho))
    (if oldDel  (setvar "DELOBJ"  oldDel))
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*QUIT*")))
      (princ (strcat "\n[中斷]: " msg))
    )
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq ms  (vla-get-ModelSpace doc))

  (setq oldEcho (getvar "CMDECHO"))
  (setq oldDel  (getvar "DELOBJ"))

  (setvar "CMDECHO" 0)
  (princ "\n【大面積極速網格裁切工具】")

  ;; 1. 選取幾何外框
  (setq entOuter nil)
  (while (not entOuter)
    (setq entOuter (car (entsel "\n請點選【外圍的大幾何外框】: ")))
  )

  ;; 2. 框選所有格子
  (princ "\n請框選【所有格子】: ")
  (setq ssBoxes (ssget '((0 . "LWPOLYLINE,POLYLINE,CIRCLE,RECTANGLE"))))

  (if ssBoxes
    (progn
      (setvar "DELOBJ" 1)   ; 自動清除原圖元
      (princ "\n正在計算範圍與遮罩...")

      ;; 計算外框的包絡矩形
      (vla-getboundingbox (vlax-ename->vla-object entOuter) 'minPt 'maxPt)
      (setq bbMin (vlax-safearray->list minPt)
            bbMax (vlax-safearray->list maxPt))
      
      ;; 放大外圍包絡矩形 (擴展 20mm)
      (setq p1 (list (- (car bbMin) 20.0) (- (cadr bbMin) 20.0) 0.0)
            p3 (list (+ (car bbMax) 20.0) (+ (cadr bbMax) 20.0) 0.0)
            p2 (list (car p3) (cadr p1) 0.0)
            p4 (list (car p1) (cadr p3) 0.0))

      ;; 建立外圍遮罩矩形 (座標前加 _non，完全不需關閉鎖點也不會吸附偏移)
      (command "_.pline" "_non" p1 "_non" p2 "_non" p3 "_non" p4 "_c")
      (command "_.region" (entlast) "")
      (setq regMask (entlast))

      ;; 複製外框並轉換為面域
      (command "_.copy" entOuter "" "_non" '(0 0 0) "_non" '(0 0 0))
      (command "_.region" (entlast) "")
      (setq regOuter (entlast))

      ;; 製作反向遮罩：regInvert = regMask - regOuter
      (command "_.subtract" regMask "" regOuter "")
      (setq regInvert regMask)

      (princ "\n正在將格子轉為面域...")
      (setq entBefore (entlast))
      (command "_.region" ssBoxes "")
      
      ;; 收集全部轉換後的格子面域
      (setq ssBoxesReg (ssadd))
      (setq entScan entBefore)
      (while (setq entScan (entnext entScan))
        (if (= (cdr (assoc 0 (entget entScan))) "REGION")
          (ssadd entScan ssBoxesReg)
        )
      )

      (if (> (sslength ssBoxesReg) 0)
        (progn
          (setq total (sslength ssBoxesReg))
          (princ (strcat "\n正在一次性極速裁切 " (itoa total) " 個格子 (請稍候)..."))

          ;; 核心：從所有格子中扣除反向遮罩
          (command "_.subtract" ssBoxesReg "" regInvert "")

          ;; -------------------------------------------------------------
          ;; 強制將 Region 轉成 Closed Polyline
          ;; -------------------------------------------------------------
          (princ "\n正在將面域轉為封閉聚合線 (Closed Polyline)...")
          (setq ssRegFinal (ssget "_X" '((0 . "REGION"))))
          
          (if (and ssRegFinal (> (sslength ssRegFinal) 0))
            (progn
              (setq entBefore (entlast))

              ;; 分解面域
              (command "_.explode" ssRegFinal "")

              ;; 收集分解出的線條
              (setq ssLines (ssadd))
              (setq entScan entBefore)
              (while (setq entScan (entnext entScan))
                (ssadd entScan ssLines)
              )

              ;; 以 0.05 容差接合
              (if (> (sslength ssLines) 0)
                (command "_.join" ssLines "" "0.05")
              )

              ;; 強制將產生的聚合線寫入 Closed = :vlax-true
              (setq entScan entBefore)
              (while (setq entScan (entnext entScan))
                (if (wcmatch (cdr (assoc 0 (entget entScan))) "*POLYLINE")
                  (vla-put-Closed (vlax-ename->vla-object entScan) :vlax-true)
                )
              )
            )
          )

          ;; -------------------------------------------------------------
          ;; 自動刪除最外圍的大幾何外框
          ;; -------------------------------------------------------------
          (if (and entOuter (entget entOuter))
            (progn
              (command "_.erase" entOuter "")
              (princ "\n已自動刪除外圍幾何外框。")
            )
          )

          (princ "\n【大功告成！】外框已刪除，所有格子已保證轉為【閉合聚合線 (Closed Polyline)】！")
        )
      )
    )
    (princ "\n未選取任何格子。")
  )

  ;; 還原環境設定 (全程不改動 OSMODE)
  (setvar "CMDECHO" oldEcho)
  (setvar "DELOBJ"  oldDel)
  (princ)
)

;; 快捷鍵
(defun c:FC () (c:FASTCUT) (princ))
(defun c:FTC () (c:FASTCUT) (princ))

(princ "\n[FASTCUT.lsp 載入成功] 輸入 FC 即可開始執行。")
(princ)
