# Cat's Clock Mojo 0.1.1 — Full HD window fix
# Copyright AC Kondo 1999-2026
# Single-file Mojo launcher + embedded Python Tkinter; no external assets.
from std.ffi import external_call, c_int

def main() raises:
    print("Cat's Clock Mojo 0.1.1 — 1920x1080")
    var command = """python3 - <<'PY'
import tkinter as tk
from datetime import datetime

WIDTH, HEIGHT = 1920, 1080
BG, BLUE, GREEN, WHITE, MUTED = '#0b1020', '#50aaff', '#7dffae', '#e6f0fa', '#7b8ba5'
root = tk.Tk()
root.title("Cat's Clock Mojo 0.1.1 | AC Kondo | 1920x1080")
root.configure(bg=BG)
root.update_idletasks()
sw, sh = root.winfo_screenwidth(), root.winfo_screenheight()
# Tk measures logical display coordinates. When the desktop is too small to
# show a 1920x1080 window, use fullscreen instead of a clipped window.
fits = sw >= WIDTH and sh >= HEIGHT
if fits:
    root.geometry(f'{WIDTH}x{HEIGHT}+{max(0,(sw-WIDTH)//2)}+{max(0,(sh-HEIGHT)//2)}')
    root.minsize(WIDTH, HEIGHT)
else:
    root.attributes('-fullscreen', True)

canvas = tk.Canvas(root, bg=BG, highlightthickness=0, bd=0)
canvas.pack(fill='both', expand=True)
mode_24h = tk.BooleanVar(value=False)

def toggle(event=None):
    mode_24h.set(not mode_24h.get())
    render()

def quit_clock(event=None):
    root.destroy()

root.bind('<Escape>', quit_clock)
root.bind('<F11>', lambda e: root.attributes('-fullscreen', not bool(root.attributes('-fullscreen'))))
root.bind('<space>', toggle)
root.bind('<Button-1>', toggle)

def render():
    canvas.delete('all')
    w, h = max(canvas.winfo_width(), 1), max(canvas.winfo_height(), 1)
    scale = min(w / WIDTH, h / HEIGHT)
    def size(n): return max(10, round(n * scale))
    now = datetime.now()
    canvas.create_text(w/2, h*0.25, text="CAT'S CLOCK MOJO", fill=BLUE,
                       font=('Menlo', size(58), 'bold'))
    fmt = '%H:%M:%S' if mode_24h.get() else '%I:%M:%S %p'
    canvas.create_text(w/2, h*0.46, text=now.strftime(fmt), fill=GREEN,
                       font=('Menlo', size(145), 'bold'))
    canvas.create_text(w/2, h*0.62, text=now.strftime('%A, %B %d, %Y'), fill=WHITE,
                       font=('Menlo', size(38)))
    canvas.create_text(w/2, h*0.76, text=('24-HOUR' if mode_24h.get() else '12-HOUR') + '  •  SPACE / CLICK TO TOGGLE',
                       fill=BLUE, font=('Menlo', size(23)))
    canvas.create_text(w/2, h*0.90, text='ESC: Exit  |  F11: Fullscreen  |  AC Kondo 1999-2026',
                       fill=MUTED, font=('Menlo', size(19)))

canvas.bind('<Configure>', lambda e: render())
def tick():
    render()
    root.after(200, tick)
root.after(100, tick)
root.mainloop()
PY"""
    var result = external_call["system", c_int](command.as_c_string_span())
    if result != 0:
        print("Clock exited with an error. Check Python 3 and tkinter.")
