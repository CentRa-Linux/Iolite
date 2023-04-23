from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

import time
import os.path
import locale

paths = ["/usr/share/applications", "/usr/local/share/applications", os.path.expanduser("~/.local/share/applications")]

def getext(filename):
    return os.path.splitext(filename)[-1].lower()

class appManager():
    apps = {}

    def empty(self):
        return

    onRescan = empty

    def rescan(self, paths):
        for path in paths:
            files = os.listdir(path)
            files = [f for f in files if os.path.isfile(path+'/'+f)]
            for file in files:
                if getext(file) != ".desktop":
                    return
                else:
                    self.apps[path+'/'+file] = self.parse(path+'/'+file)

    def parse(self, path):
        app = []
        data = {}
        localized = {}
        with open(path) as f:
            for line in f:
                if line.startswith('#'):
                    continue
                if line == '' or line == '\n':
                    continue
                if line.startswith('[') and line.endswith("]\n"):
                    if data != {}:
                        app.append(data)
                        data = {}
                    continue
                if '=' in line:
                    value = line.split('=')[1].rstrip()
                    if '[' and ']' in line:
                        key = line.split('[')[0]
                        if line.split('[')[1].split(']')[0] == locale.getlocale()[0]:
                            data[key] = value
                            localized[key] = True
                        elif not key in localized:
                            if line.split('[')[1].split(']')[0] == locale.getlocale()[0].split('_')[0]:
                                data[key] = value
                    else:
                        key = line.split('=')[0]
                        data[key] = value
            if data != {}:
                app.append(data)
        return app

    def start(self, paths):
        self.rescan(paths)

        AppManagerSelf = self

        class EventHandler(FileSystemEventHandler):
            def on_any_event(self, e):
                AppManagerSelf.onRescan()
            def on_created(self, e):
                if e.is_directory:
                    return
                if getext(e.src_path) == ".desktop":
                    AppManagerSelf.apps[e.src_path] = AppManagerSelf.parse(e.src_path)
            def on_moved(self, e):
                if e.is_directory:
                    return
                if getext(e.dest_path) == ".desktop":
                    AppManagerSelf.apps.pop(e.src_path, [])
                    AppManagerSelf.apps[e.dest_path] = AppManagerSelf.parse(e.dest_path)
            def on_deleted(self, e):
                if e.is_directory:
                    return
                if getext(e.src_path) == ".desktop":
                    AppManagerSelf.apps.pop(e.src_path, [])
            def on_modified(self, e):
                if e.is_directory:
                    return
                if getext(e.src_path) == ".desktop":
                    AppManagerSelf.apps[e.src_path] = AppManagerSelf.parse(e.src_path)

        observer = Observer()
        for path in paths:
            observer.schedule(EventHandler(), path, recursive=True)
        observer.start()

if __name__ == "__main__":
    instance = appManager()
    instance.start(paths)

    while True:
        time.sleep(5)
