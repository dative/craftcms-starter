/* eslint-disable @typescript-eslint/no-explicit-any */
import { defineConfig, normalizePath } from 'vite';
import { resolve } from 'path';

const nPath = (path) => normalizePath(resolve(__dirname, path));

export default defineConfig(() => ({
  base: '',
  publicDir: nPath('./src/static'),
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
    },
  },
  build: {
    manifest: false,
    cssCodeSplit: false,
    outDir: nPath('cms/config/redactor/plugins'),
    copyPublicDir: false,
    emptyOutDir: true,
    rollupOptions: {
      input: './src/css/siteRedactorStyles.css',
      output: {
        sourcemap: false,
        entryFileNames: 'siteRedactorStyles.js',
        assetFileNames: 'siteRedactorStyles.[ext]',
      },
    },
  },
}));
