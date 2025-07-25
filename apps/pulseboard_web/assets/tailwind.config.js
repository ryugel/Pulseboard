const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/pulseboard_web_web.ex",
    "../lib/pulseboard_web_web/**/*.*ex"
  ],
  theme: {
    extend: {
      colors: {
        brand: "#FD4F00",
        surface: "#111827",     // Background dark
        panel: "#1f2937",       // Panel dark
        accent: "#6366f1",      // Indigo-like CTA
        subtle: "#4B5563",      // Muted text
      },
      animation: {
        "fade-in": "fadeIn 0.6s ease-out forwards",
        "slide-up": "slideUp 0.5s ease-out forwards",
        "pulse-slow": "pulse 3s ease-in-out infinite",
      },
      keyframes: {
        fadeIn: {
          "0%": { opacity: 0, transform: "translateY(20px)" },
          "100%": { opacity: 1, transform: "translateY(0)" },
        },
        slideUp: {
          "0%": { transform: "translateY(30px)", opacity: 0 },
          "100%": { transform: "translateY(0)", opacity: 1 },
        },
      }
    },
  },
  plugins: [
    require("@tailwindcss/forms"),

    // LiveView-specific variants
    plugin(({ addVariant }) =>
      addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])
    ),

    // Heroicons as CSS masks
    plugin(function ({ matchComponents, theme }) {
      const iconsDir = path.join(__dirname, "../../../deps/heroicons/optimized")
      const values = {}

      const variants = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"],
        ["-micro", "/16/solid"]
      ]

      variants.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach((file) => {
          const name = path.basename(file, ".svg") + suffix
          values[name] = {
            name,
            fullPath: path.join(iconsDir, dir, file),
          }
        })
      })

      matchComponents({
        hero: ({ name, fullPath }) => {
          const content = fs.readFileSync(fullPath, "utf8").replace(/\r?\n|\r/g, "")
          let size = theme("spacing.6")
          if (name.endsWith("-mini")) size = theme("spacing.5")
          if (name.endsWith("-micro")) size = theme("spacing.4")

          return {
            [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            "-webkit-mask": `var(--hero-${name})`,
            "mask": `var(--hero-${name})`,
            "mask-repeat": "no-repeat",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": size,
            "height": size,
          }
        }
      }, { values })
    })
  ]
}
