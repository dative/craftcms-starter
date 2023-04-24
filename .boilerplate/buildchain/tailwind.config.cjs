/** @type {import('tailwindcss').Config} */
module.exports = {
  presets: [require('./tailwind.preset.cjs')],
  content: [
    './cms/templates/**/*.{twig,html}',
    './cms/config/redactor/**/*.json',
    './src/js/**/*.{js,ts}'
  ],
  safelist: [
    'bg-transparent',
    'bg-gold',
    'bg-blue',
    'bg-clover',
    'bg-calm-300',
    'text-gold',
    'text-blue',
    'text-clover',
    'text-calm-300',
    'border-gold',
    'border-blue',
    'border-clover',
    'border-white',
    'text-charcoal',
    'rtf-left',
    'rtf-right',
    'rtf-center'
  ]
}
