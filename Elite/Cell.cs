using Accessibility;

namespace Elite
{
    public sealed class FontStyle
    {
        [Flags]
        private enum Attribute : byte
        {
            None = 0x00,
            Bold = 0x01,
            Italic = 0x02,
            Underlined = 0x04,
            StrikeThrough = 0x08
        }

        private Attribute _attribute = Attribute.None;

        public string Name { get; set; } = "";
        public ushort Size { get; set; }
        public Color Color { get; set; }
        public bool IsBold { get => _attribute.HasFlag(Attribute.Bold); set => _attribute |= Attribute.Bold; }
        public bool IsItalic { get => _attribute.HasFlag(Attribute.Italic); set => _attribute |= Attribute.Italic; }
        public bool IsUnderlined { get => _attribute.HasFlag(Attribute.Underlined); set => _attribute |= Attribute.Underlined; }
        public bool IsStrikeThrough { get => _attribute.HasFlag(Attribute.StrikeThrough); set => _attribute |= Attribute.StrikeThrough; }
    }

    public sealed class BorderEdgeStyle
    {
        public Color Color { get; set; } = Color.Black;
        public byte Thickness { get; set; } = 0;
    }

    public sealed class BorderEdgeStyles
    {
        public BorderEdgeStyle Top { get; } = new();
        public BorderEdgeStyle Left { get; } = new();
        public BorderEdgeStyle Bottom { get; } = new();
        public BorderEdgeStyle Right { get; } = new();
    }

    public sealed class CellStyle
    {
        public static readonly CellStyle Default = GetDefault();

        public static CellStyle GetDefault()
        {
            var cell = new CellStyle();
            cell.BackgroundColor = Color.White;
            cell.Font.Name = "Aptos Narrow";
            cell.Font.Size = 11;
            cell.Font.Color = Color.Black;
            cell.Border.Top.Color = Color.LightGray;
            cell.Border.Top.Thickness = 1;
            cell.Border.Left.Color = Color.LightGray;
            cell.Border.Left.Thickness = 1;
            cell.Border.Bottom.Color = Color.LightGray;
            cell.Border.Bottom.Thickness = 1;
            cell.Border.Right.Color = Color.LightGray;
            cell.Border.Right.Thickness = 1;
            return cell;
        }

        public Color BackgroundColor { get; set; } = Color.White;
        public FontStyle Font { get; } = new();
        public BorderEdgeStyles Border { get; } = new();
    }

    public sealed class SheetCell
    {
        public string? Formula { get; set; }

        private object? _value;
        public object? Value
        {
            get => _value;
            set
            {
                if (_value == value)
                    return;
                if (null == value)
                {
                    _value = null;
                    return;
                }

                if (null != Type)
                {
                    if (value.GetType() == Type)
                    {
                        _value = value;
                        return;
                    }

                    _value = Convert.ChangeType(value, Type);
                    return;
                }

                _value = value switch
                {
                    null => value,
                    bool => value,
                    byte or sbyte or ushort or short or uint or int or long or ulong => value,
                    float or double => value,
                    decimal => value,
                    string => value,
                    DateTime => value,
                    TimeSpan => value,
                    _ => throw new ApplicationException($"Value of type [{value.GetType().Name}] is not supported."),
                };
            }
        }

        public Type? Type { get; set; }

        public string? Format { get; set; }

        private CellStyle? _style;
        public CellStyle Style
        {
            get
            {
                if (null == _style) _style = CellStyle.GetDefault();
                return _style;
            }
        }
        public bool HasStyle => null != _style;
    }
}
