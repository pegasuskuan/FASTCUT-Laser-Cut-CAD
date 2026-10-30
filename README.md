# FASTCUT.lsp

> **High-performance Grid Trimming & Boundary Auto-Closing Tool for Laser Cutting in AutoCAD / progeCAD**  
> **AutoCAD / progeCAD 雷射切割專用：大面積網格邊界極速裁切與自動封閉工具**

[English](#-english) | [繁體中文](#-繁體中文)

---

## 🌐 English

### Overview
In laser cutting and CNC fabrication, engineers often need to populate a large array of grid holes (e.g., 1mm or 2mm squares, circles, hex honeycomb) inside an irregular geometric boundary.

#### Key Problems with Native CAD Tools:
1. **`EXTRIM` Limitations**: Can only trim one boundary entity at a time, leaving boundary holes with **open gaps (unclosed profiles)** that laser cutters cannot process cleanly.
2. **Time-Consuming Manual Patching**: Manually closing hundreds or thousands of cut holes takes hours.
3. **Overlapping & Duplicate Lines**: Results in double-cutting and scorched edges on workpieces.

#### The `FASTCUT` Solution:
**`FASTCUT.lsp`** uses an advanced **Inverted Mask Boolean Subtraction** algorithm:
* ⚡ **High-Speed Batch Processing**: Trims hundreds to tens of thousands of holes in **one single selection within 2–5 seconds**.
* 🔒 **100% Closed Polylines**: Any hole intercepted by the boundary is **automatically sealed and converted into a closed polyline** matching the boundary contour.
* 🔷 **Arbitrary Geometry Support**: Supports squares, rectangles, circles, ellipses, hexagons (honeycomb), diamonds, or custom closed polyline shapes.
* 🗑️ **Auto Cleanup**: Automatically removes the outer boundary template upon completion.
* 🛡️ **Snap (OSMODE) Protection**: Never resets, disables, or alters the user's object snap settings.
* ⌨️ **Quick Aliases**: Trigger instantly with shortcut `FC` or `FTC`.
* 💻 **Cross-Platform Compatibility**: Fully compatible with both **AutoCAD** and **progeCAD**.

---

### Quick Start

#### 1. Load the Tool
* **Drag & Drop**: Simply drag `FASTCUT.lsp` into your AutoCAD / progeCAD drawing canvas.
* *(Or type `APPLOAD`, select `FASTCUT.lsp`, and click Load)*.

#### 2. Execute Command
Type any of the following in the command line:
```text
FC     (Recommended quick shortcut)
or
FTC
or
FASTCUT
```

#### 3. Workflow
1. `請點選【外圍的大幾何外框】:` ➔ **Click your outer closed boundary contour**.
2. `請框選【所有格子】:` ➔ **Window-select all grid shapes / holes**, then press **Enter**.
3. **Done!** The outer boundary is automatically cleaned up, and all retained holes (including boundary-trimmed ones) are guaranteed to be sealed **Closed Polylines** ready for DXF export.

---

### Prerequisites & Fabrication Tips

#### 🔴 Prerequisites
1. **Outer Boundary Must Be Closed**:
   * The outer boundary must be a closed geometric shape.
   * *Tip: If the boundary has micro-gaps or self-intersections, use the `BO` (BOUNDARY) command to generate a clean polyline boundary.*
2. **Each Hole Must Be an Independent Closed Entity**:
   * Each grid shape must be a closed object (`Closed Polyline`, `Circle`, etc.), not loose, individual lines.
   * If grids were created via `ARRAY`, ensure you **explode (`X`)** the array into individual entities first.

#### 💡 Laser Cutting Tips
1. **Zero Lead-in for Small Holes (< 2mm)**: Set lead-in length to `0` or use center piercing to prevent piercing explosions from blowing through thin 1mm walls.
2. **Enable FlyCut**: For dense micro-hole arrays, enable **FlyCut / Grid FlyCut** in your laser software (e.g., CypCut, LightBurn) to cut processing time from hours down to minutes and minimize heat distortion.

---

## 🇹🇼 繁體中文

### 簡介
在雷射切割（Laser Cut）製程中，經常需要在不規則外框內部排列大量網格或幾何孔洞（如 1mm/2mm 方孔、圓孔、六角蜂巢孔等）。

#### 傳統做法的痛點：
1. **`EXTRIM` 缺陷**：只能單個手動點選，且裁切後邊界格子會形成**缺口破線（未閉合）**，雷切無法成形。
2. **手動修補耗時**：遇到數百至數萬個小孔時，手動補線極耗工時。
3. **容易產生重疊線**：導致雷射重複切割、材料燒焦。

#### `FASTCUT` 技術特色：
**`FASTCUT.lsp`** 採用「反向遮罩差集運算」技術：
* ⚡ **極速批次處理**：數百到上萬個孔洞，只需 **1 次選取、2~5 秒內完成**。
* 🔒 **自動密封（Closed Polyline）**：被幾何外框切到的邊緣孔洞，**100% 自動沿著外框補線封閉**。
* 🔷 **支援任意幾何形狀**：正方形、長方形、圓形、橢圓、六角蜂巢孔、菱形、星形或自訂異形皆通用。
* 🔄 **面域自動轉聚合線**：裁切後自動轉為封閉 Polyline，完美銜接雷切軟體路徑。
* 🗑️ **自動刪除外框**：運算完成自動清除外框，免手動清理。
* 🛡️ **保護 Snap 設定**：全程使用無鎖點模式，絕對不關閉、不重置使用者的物件鎖點（OSMODE）。
* ⌨️ **支援超短快捷鍵**：支援 `FC` 或 `FTC`，左手盲打極速執行。
* 💻 **雙平臺支援**：相容 **AutoCAD** 與 **progeCAD**。

---

### 快速上手

#### 1. 載入外掛
* **直接拖曳**：將 `FASTCUT.lsp` 檔案直接拖入 AutoCAD / progeCAD 繪圖視窗放開。
* *(或使用 `APPLOAD` 指令載入)*

#### 2. 執行快捷鍵
在指令列輸入快捷鍵（二選一）：
```text
FC     (推薦，超短快捷鍵)
或
FTC
或
FASTCUT
```

#### 3. 操作流程
1. `請點選【外圍的大幾何外框】:` ➔ **點選封閉幾何大外框**。
2. `請框選【所有格子】:` ➔ **滑鼠框選全部的網格/幾何孔洞**，按 **Enter**。
3. **完成！** 外框自動清除，所有孔洞（包括被切邊的）100% 密封為 Closed Polyline。

---

### 使用前提要求與注意事項

#### 🔴 重要前提要求
1. **外框必須是封閉幾何（Closed）**：
   * 外圍大幾何外框必須是閉合的封閉多邊形。
   * *💡 若外框線條不平整或無法建立面域，可在內部空白處輸入 `BO`（邊界指令）點一下重繪乾淨外框。*
2. **小孔/小格子必須是「獨立且封閉的個體」**：
   * 不管是正方形、圓形、六角形、菱形還是自訂異形，每個小孔必須是**單一封閉物件（Closed Polyline / Circle）**，不能是由散開的獨立直線拼成。
   * 若小孔是用 `ARRAY`（陣列）排出來的，請務必先框選輸入 **`X`（`EXPLODE`）分解一次**。

#### 💡 雷切加工建議
1. **1mm 孔洞引刀線設定**：孔洞小於 2mm 時，請將雷切軟體的引刀線（Lead-in）設為 `0` 或中心穿刺，避免起刀時爆孔炸穿薄壁。
2. **啟用「飛切 (FlyCut)」**：大面積密集微孔建議搭配雷切機軟體（如 CypCut / LightBurn）的「網格飛切 / 連續飛切」功能，加工速度提升 10 倍以上並大幅降低熱變形。

---

## 📄 授權 (License)

本專案採用 **[GNU General Public License v3.0 (GPLv3)](LICENSE)** 授權開源。  
Licensed under the GNU General Public License v3.0.
