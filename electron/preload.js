const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('snapdrop', {
  getStatus: () => ipcRenderer.invoke('get-status'),
  restartService: () => ipcRenderer.invoke('restart-service'),
  runEnable: () => ipcRenderer.invoke('run-enable'),
  getSettings: () => ipcRenderer.invoke('get-settings'),
  setLaunchAtLogin: (enabled) => ipcRenderer.invoke('set-launch-at-login', enabled),
  chooseSaveDir: () => ipcRenderer.invoke('choose-save-dir'),
  openSaveDir: () => ipcRenderer.invoke('open-save-dir'),
  copyFile: (name) => ipcRenderer.invoke('copy-file', name),
  onFileUploaded: (cb) => {
    const handler = (_e, file) => cb(file);
    ipcRenderer.on('file-uploaded', handler);
    return () => ipcRenderer.removeListener('file-uploaded', handler);
  },
});
