using System.Drawing.Drawing2D;
using System.Drawing.Text;

namespace Elite
{
    public class Canvas : Control
    {
        private static readonly Dictionary<Color, Pen> _pens = new();
        private static readonly Dictionary<Color, Brush> _brushes = new();
        private static readonly Dictionary<string, Font> _fonts = new();
        private static readonly Dictionary<string, StringFormat> _stringFormats = new();

        private readonly List<Sheet> _sheets = new();

        private Point _mouse = new();
        private Point _offset = new();

        public Canvas() => DoubleBuffered = true;

        public byte Count => (byte)_sheets.Count;
        public void Add(Sheet sheet)
        {
            if (255 == _sheets.Count)
                throw new ApplicationException("Maximum number of sheets per page is 255.");
            _sheets.Add(sheet);
        }
        public void Remove(Sheet sheet) => _sheets.Remove(sheet);
        public void Clear() => _sheets.Clear();
        public bool TryGet(string name, out Sheet? sheet)
        {
            var foundSheets = _sheets.Where(i => i.Name == name).ToArray();
            if (1 == foundSheets.Length)
            {
                sheet = foundSheets[0];
                return true;
            }
            sheet = null;
            return false;
        }
        public bool TryGet(Guid id, out Sheet? sheet)
        {
            var foundSheets = _sheets.Where(i => i.Id == id).ToArray();
            if (1 == foundSheets.Length)
            {
                sheet = foundSheets[0];
                return true;
            }
            sheet = null;
            return false;
        }

        protected override void OnPaint(PaintEventArgs e)
        {
            var g = e.Graphics;
            g.CompositingQuality = CompositingQuality.HighQuality;
            g.InterpolationMode = InterpolationMode.HighQualityBicubic;
            g.SmoothingMode = SmoothingMode.HighQuality;
            g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;

            foreach (var sheet in _sheets)
                sheet.Paint(e.Graphics, _pens, _brushes, _fonts, _stringFormats, _offset);

            g.DrawRectangle(Pens.Black, 0, 0, Width - 1, Height - 1);

            base.OnPaint(e);
        }

        protected override void OnMouseDown(MouseEventArgs e)
        {
            _mouse = e.Location;

            base.OnMouseDown(e);
        }

        protected override void OnMouseMove(MouseEventArgs e)
        {
            if (MouseButtons.Right == e.Button)
            {
                _offset = new Point(_offset.X + e.Location.X - _mouse.X, _offset.Y + e.Location.Y - _mouse.Y);
                _mouse = e.Location;
                Refresh();
            }

            base.OnMouseMove(e);
        }

        protected override void OnMouseUp(MouseEventArgs e)
        {
            if (MouseButtons.Right == e.Button)
            {
                _offset = new Point(_offset.X + e.Location.X - _mouse.X, _offset.Y + e.Location.Y - _mouse.Y);
                _mouse = e.Location;
                Refresh();
            }

            base.OnMouseUp(e);
        }

        protected override void OnDoubleClick(EventArgs e)
        {
            SheetCell? cell = null;
            foreach (var sheet in _sheets)
            {
                if (sheet.TryGet(_offset, _mouse, out cell))
                    break;
            }

            base.OnDoubleClick(e);
        }
    }
}
