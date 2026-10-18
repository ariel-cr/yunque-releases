# Yunque — distribución de binarios

Subagentes nativos para desarrollar juegos Godot desde OpenCode, Codex y Claude Code. Este repositorio distribuye los instaladores y binarios; el código fuente está en un repositorio privado.

## Instalación

Linux y macOS:

```sh
curl -fsSL https://raw.githubusercontent.com/ariel-cr/yunque-releases/main/install.sh | bash
```

Windows, desde PowerShell:

```powershell
irm https://raw.githubusercontent.com/ariel-cr/yunque-releases/main/install.ps1 | iex
```

El instalador descarga el binario y registra siete especialistas y una skill coordinadora en los anfitriones detectados. Conserva archivos y configuraciones ajenos. Reinicia el anfitrión y abre la carpeta de tu juego: `project.godot` debe estar en el directorio actual o en un ancestro.

No necesitas aprender comandos para conversar. Pide tu tarea normalmente en el anfitrión; este selecciona los especialistas pertinentes. Una consulta sencilla no activa todo un equipo. El modelo, las herramientas y los permisos son los del anfitrión. La decisión de seleccionar skills y delegar depende de sus capacidades y configuración.

## Ubicaciones

El binario se instala en `~/.local/bin` (Linux/macOS) o `%LOCALAPPDATA%\Yunque` (Windows). Los subagentes usan las rutas nativas de cada anfitrión:

- Codex: `~/.codex/agents`; skill en `~/.agents/skills/yunque`.
- Claude Code: `~/.claude/agents` y `~/.claude/skills/yunque`.
- OpenCode: `~/.config/opencode/agents` y `~/.config/opencode/skills/yunque`.

Se respetan las variables de configuración de los anfitriones. Si instalas un anfitrión después, ejecuta `yunque install-agents`; puedes elegirlo con `--agent codex`, `--agent claude` o `--agent opencode`. `agents-status` muestra el estado y `uninstall-agents` retira archivos administrados sin modificaciones.

Para fijar versión o carpeta en Bash, guarda primero el instalador y pasa las variables al proceso que lo ejecuta:

```sh
curl -fsSL https://raw.githubusercontent.com/ariel-cr/yunque-releases/main/install.sh -o /tmp/install-yunque.sh
YUNQUE_VERSION=v0.1.0 YUNQUE_INSTALL_DIR="$HOME/.local/bin" bash /tmp/install-yunque.sh
```

## Biblias, contexto e idioma por proyecto

Cada juego guarda su memoria en `.yunque/`, junto a `project.godot`: `contexto.md`,
`decisiones.md`, `pendientes.md`, `assets.json`, `biblias/` y `personajes/`.
Los agentes leen esos documentos al retomar y el coordinador combina y guarda los
cambios al cerrar una tarea. La actualización del binario no borra esa memoria.
Los documentos y biblias anteriores se descubren y conservan sin migración automática.

El contenido nuevo se redacta en el idioma en que el usuario habla a la IA. Los
textos existentes conservan su idioma y se traducen sólo si se solicita. Las rutas
y campos técnicos permanecen estables. El anfitrión redacta y actualiza los documentos;
Yunque persiste UTF-8 y rechaza escrituras con una revisión obsoleta. No se añade
una API de traducción ni un modelo propio. Inicializar prepara estructura y archivos
vacíos; el agente completa la información real del juego sin comandos manuales del usuario.

La memoria puede compartirse con el proyecto mediante tu control de versiones;
no incluye el historial completo del chat ni debe contener secretos. Su lectura y
actualización por el modelo dependen del cumplimiento de las instrucciones nativas
por parte del anfitrión. Reinícialo después de actualizar para cargar esas instrucciones.

## Assets y claves

El agente recomienda servicios cuando corresponda y ofrece preparar un `.env`. Solo con consentimiento crea nombres de variables vacías. El usuario escribe las claves localmente; no se solicitan por chat. Se conserva el `.env` existente y se añaden exclusiones Git. Esto no carga las variables en Godot ni autoriza llamadas de pago. No exportes secretos en el juego.

## Descarga manual y requisitos

[Descargas por versión](https://github.com/ariel-cr/yunque-releases/releases):

| Plataforma | Archivo |
|---|---|
| Linux x86_64 | `yunque-linux-x86_64` |
| Windows x86_64 | `yunque-windows-x86_64.exe` |
| macOS Intel | `yunque-macos-x86_64` |
| macOS Apple Silicon | `yunque-macos-arm64` |

No necesitas Python para usar el binario. Necesitas un anfitrión compatible y Godot para ejecutar sus herramientas locales. Tras una descarga manual, ejecuta `yunque install-agents --binary /ruta/absoluta/yunque`.

Los subagentes globales pueden verse fuera de Godot; sus instrucciones exigen detenerse y las herramientas locales rechazan trabajar allí. Yunque no añade un sandbox a las herramientas del anfitrión.

Proyecto privado; los binarios se proporcionan para uso autorizado.
