#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec2 ScreenSize;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform vec2 Resolution;
uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;


void main()
{
    // vanilla behavior
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;

    // Remove text shadow from
    if (Color.xyz == vec3(78/255., 92/255., 36/255.) && (Position.z == 0.03 || Position.z == 0.06 || Position.z == 0.12)) {
        vertexColor.rgb = texelFetch(Sampler2, UV2 / 16, 0).rgb; // remove color from no shadow marker

        if (gl_Position.y < 0.3 && gl_Position.y > 0.0)
            gl_Position.xyw += vec3(1.3, 0.975, 0.2); // Move mana bar to top right corner and shrink it by 20%

        if (gl_Position. x > 1.8)
            gl_Position.xy -= vec2(0.757, 0.227); // Move mana exhaustion icon to it's right place

        if (gl_Position.y < 0.0 && gl_Position.y > -0.45)
            gl_Position.xyw += vec3(1.12, 1.231, 0.53); // Move mana exhaustion bar to top right corner and shrink it by 50%

    }
    else if (Color.xyz == vec3(19/255., 23/255., 9/255.) && Position.z == 0)
        vertexColor.a = 0 ; // make shadow invisible

    else if (Color.xyz == vec3(74/255., 88/255., 32/255.) || (Color.xyz == vec3(18/255., 22/255., 8/255.)) && Position.z == 0)
        vertexColor.a = 0 ; // make mana exhaustion invisible when not needed
}