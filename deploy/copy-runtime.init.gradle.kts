// Copia el classpath de ejecucion junto al jar, para arrancar sin Jib.
// Solo lo usa el Dockerfile de Railway; el build de siempre no lo carga.
allprojects {
    if (name == "wallet-provider-service") {
        afterEvaluate {
            tasks.register<Copy>("copyRuntimeLibs") {
                dependsOn("jar")
                from(configurations.getByName("runtimeClasspath"))
                from(tasks.named("jar"))
                into(layout.buildDirectory.dir("runtime-libs"))
            }
        }
    }
}
