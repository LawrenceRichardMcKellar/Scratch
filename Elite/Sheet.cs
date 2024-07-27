namespace Elite
{
    public sealed class Sheet
    {
        public Guid Id { get; }
        public string Name { get; set; }
        public Point Location { get; set; } = new();

        private SheetCell[,] _sheet;
        private uint _rows;
        private uint _columns;
        private ushort[] _rowHeights;
        private ushort[] _columnWidths;

        public Sheet(SheetCell[,] sheet, string name = "", Point location = new())
        {
            Id = Guid.NewGuid();
            Name = name;
            Location = location;

            _sheet = sheet;
            _rows = (uint)_sheet.GetLength(0);
            _rowHeights = Enumerable.Range(0, (int)_rows).Select(i => (ushort)24).ToArray();
            _columns = (uint)_sheet.GetLength(0);
            _columnWidths = Enumerable.Range(0, (int)_columns).Select(i => (ushort)96).ToArray();
        }

        public uint Rows => _rows;
        public uint Columns => _columns;
        public SheetCell this[uint row, uint column]
        {
            get
            {
                var cell = _sheet[row, column];
                if (null == cell)
                    _sheet[row, column] = cell = new();
                return cell;
            }
        }

        public bool TryGet(Point offset, Point mouse, out SheetCell? cell)
        {
            var x = mouse.X - Location.X - offset.X;
            var y = mouse.Y - Location.Y - offset.Y;

            if (x < 0 || y < 0)
            {
                cell = null;
                return false;
            }

            var row = -1;
            var ro = 0;
            for (var r = 0; r < _rows; r++)
            {
                var h = _rowHeights[r];

                if (y >= ro && y < ro + h)
                {
                    row = r;
                    break;
                }

                ro += h;
            }
            if (-1 == row)
            {
                cell = null;
                return false;
            }

            var column = -1;
            var co = 0;
            for (var c = 0; c < _columns; c++)
            {
                var w = _columnWidths[c];

                if (x >= co && x < co + w)
                {
                    column = c;
                    break;
                }

                co += w;
            }
            if (-1 == column)
            {
                cell = null;
                return false;
            }

            cell = _sheet[row, column];
            return true;
        }

        internal void Paint(
            Graphics graphics,
            Dictionary<Color, Pen> pens,
            Dictionary<Color, Brush> brushes,
            Dictionary<string, Font> fonts,
            Dictionary<string, StringFormat> stringFormats,
            Point offset
        )
        {
            var x = Location.X + offset.X;
            var y = Location.Y + offset.Y;

            var ro = 0;
            for (var row = 0; row < _rows; row++)
            {
                var h = _rowHeights[row];
                var co = 0;
                for (var column = 0; column < _columns; column++)
                {
                    var w = _columnWidths[column];

                    var cell = _sheet[row, column];

                    var @string = cell?.Value?.ToString();

                    var style = (cell?.HasStyle ?? false) ? cell.Style : CellStyle.Default;

                    if (!brushes.TryGetValue(style.BackgroundColor, out var brush))
                        brushes.Add(style.BackgroundColor, brush = new SolidBrush(style.BackgroundColor));
                    graphics.FillRectangle(brush, x + co, y + ro, w, h);
                    DrawBorder(pens, style.BackgroundColor, style.Border.Top, x + co, y + ro, x + co + w, y + ro);
                    DrawBorder(pens, style.BackgroundColor, style.Border.Left, x + co, y + ro, x + co, y + ro + h);
                    DrawBorder(pens, style.BackgroundColor, style.Border.Bottom, x + co, y + ro + h, x + co + w, y + ro + h);
                    DrawBorder(pens, style.BackgroundColor, style.Border.Right, x + co, y + ro + h, x + co + w, y + ro + h);

                    if (!string.IsNullOrEmpty(@string))
                    {
                        if (!brushes.TryGetValue(style.Font.Color, out brush))
                            brushes.Add(style.Font.Color, brush = new SolidBrush(style.Font.Color));

                        var key = $"{style.Font.Name}:{style.Font.Size}";
                        if (!fonts.TryGetValue(key, out var font))
                            fonts.Add(key, font = new Font(style.Font.Name, style.Font.Size));

                        var stringFormat = new StringFormat(StringFormatFlags.NoWrap | StringFormatFlags.FitBlackBox)
                        {
                            Alignment = StringAlignment.Near,
                            LineAlignment = StringAlignment.Center,
                            Trimming = StringTrimming.EllipsisCharacter
                        };

                        var rect = new RectangleF(x + co, y + ro, w, h);
                        graphics.DrawString(@string, font!, brush, rect, stringFormat);
                    }

                    void DrawBorder(Dictionary<Color, Pen> pens, Color backgroundColor, BorderEdgeStyle borderEdgeStyle, int x1, int y1, int x2, int y2)
                    {
                        var color = 0 == borderEdgeStyle.Thickness ? backgroundColor : borderEdgeStyle.Color;
                        if (!pens.TryGetValue(color, out var pen))
                            pens.Add(borderEdgeStyle.Color, pen = new(borderEdgeStyle.Color));
                        graphics.DrawLine(pen, x1, y1, x2, y2);
                    }

                    co += w;
                }
                ro += h;
            }

        }

    }
}
